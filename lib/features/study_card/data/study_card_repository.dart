import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/study_card.dart';
import '../domain/study_card_set.dart';

class StudyCardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ------------------------------------------------------------
  // CURRENT USER
  // ------------------------------------------------------------

  User get _currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw StateError('Kein Benutzer angemeldet.');
    }

    return user;
  }

  // ------------------------------------------------------------
  // MY SETS
  // users/{userId}/studyCardSets
  // ------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get _sets {
    return _firestore
        .collection('users')
        .doc(_currentUser.uid)
        .collection('studyCardSets');
  }

  // ------------------------------------------------------------
  // PUBLIC SETS
  // publicStudyCardSets/{userId_setId}
  // ------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get _publicSets {
    return _firestore.collection('publicStudyCardSets');
  }

  DocumentReference<Map<String, dynamic>> _publicSetReference(
    String userId,
    String setId,
  ) {
    return _publicSets.doc('${userId}_$setId');
  }

  // ============================================================
  // MY SETS
  // ============================================================

  Future<List<StudyCardSet>> getStudyCardSets() async {
    final snapshot = await _sets.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return StudyCardSet(
        id: doc.id,
        title: data['title'] as String? ?? '',
        description: data['description'] as String? ?? '',
        isPublic: data['isPublic'] as bool? ?? false,
      );
    }).toList();
  }

  // Stream so copied Explore sets appear automatically
  // in "Meine Sets".
  Stream<List<StudyCardSet>> watchStudyCardSets() {
    return _sets.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return StudyCardSet(
          id: doc.id,
          title: data['title'] as String? ?? '',
          description: data['description'] as String? ?? '',
          isPublic: data['isPublic'] as bool? ?? false,
        );
      }).toList();
    });
  }

  Future<void> createStudyCardSet(StudyCardSet studyCardSet) async {
    final docRef = await _sets.add({
      'title': studyCardSet.title,
      'description': studyCardSet.description,
      'isPublic': studyCardSet.isPublic,
    });

    // If the user creates it as public, publish a copy.
    if (studyCardSet.isPublic) {
      await _syncPublicSet(docRef.id);
    }
  }

  Future<void> updateStudyCardSet(StudyCardSet studyCardSet) async {
    await _sets.doc(studyCardSet.id).update({
      'title': studyCardSet.title,
      'description': studyCardSet.description,
      'isPublic': studyCardSet.isPublic,
    });

    if (studyCardSet.isPublic) {
      // Update the published version.
      await _syncPublicSet(studyCardSet.id);
    } else {
      // Set is private now -> remove it from Explore.
      await _deletePublicSnapshot(studyCardSet.id);
    }
  }

  Future<void> deleteStudyCardSet(String setId) async {
    // Remove published version first, if there is one.
    await _deletePublicSnapshot(setId);

    final studyCardsSnapshot = await _sets
        .doc(setId)
        .collection('studyCards')
        .get();

    final batch = _firestore.batch();

    for (final document in studyCardsSnapshot.docs) {
      batch.delete(document.reference);
    }

    batch.delete(_sets.doc(setId));

    await batch.commit();
  }

  // ============================================================
  // MY CARDS
  // ============================================================

  Future<List<StudyCard>> getCards(String setId) async {
    final snapshot = await _sets.doc(setId).collection('studyCards').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return StudyCard(
        id: doc.id,
        question: data['question'] as String? ?? '',
        answer: data['answer'] as String? ?? '',
      );
    }).toList();
  }

  Future<void> createCard(String setId, StudyCard card) async {
    await _sets.doc(setId).collection('studyCards').add({
      'question': card.question,
      'answer': card.answer,
    });

    // If this set is public, update its Explore copy.
    if (await _isSetPublic(setId)) {
      await _syncPublicSet(setId);
    }
  }

  Future<void> updateCard(String setId, StudyCard card) async {
    await _sets.doc(setId).collection('studyCards').doc(card.id).update({
      'question': card.question,
      'answer': card.answer,
    });

    if (await _isSetPublic(setId)) {
      await _syncPublicSet(setId);
    }
  }

  Future<void> deleteCard(String setId, String cardId) async {
    await _sets.doc(setId).collection('studyCards').doc(cardId).delete();

    if (await _isSetPublic(setId)) {
      await _syncPublicSet(setId);
    }
  }

  Future<bool> _isSetPublic(String setId) async {
    final snapshot = await _sets.doc(setId).get();

    if (!snapshot.exists) {
      return false;
    }

    final data = snapshot.data();

    return data?['isPublic'] as bool? ?? false;
  }

  // ============================================================
  // PUBLISH / EXPLORE
  // ============================================================

  /// Copies the owner's current set into publicStudyCardSets.
  ///
  /// This is the public Explore version.
  Future<void> _syncPublicSet(String setId) async {
    final userId = _currentUser.uid;

    final privateSetRef = _sets.doc(setId);
    final privateSetSnapshot = await privateSetRef.get();

    if (!privateSetSnapshot.exists) {
      return;
    }

    final setData = privateSetSnapshot.data()!;

    final isPublic = setData['isPublic'] as bool? ?? false;

    if (!isPublic) {
      await _deletePublicSnapshot(setId);
      return;
    }

    final privateCardsSnapshot = await privateSetRef
        .collection('studyCards')
        .get();

    final publicSetRef = _publicSetReference(userId, setId);

    // First create/update the public parent document.
    await publicSetRef.set({
      'title': setData['title'] as String? ?? '',
      'description': setData['description'] as String? ?? '',
      'isPublic': true,

      // Used by Firestore Security Rules.
      'ownerId': userId,

      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Delete the old public cards.
    final oldPublicCards = await publicSetRef.collection('studyCards').get();

    final batch = _firestore.batch();

    var hasWrites = false;

    for (final oldCard in oldPublicCards.docs) {
      batch.delete(oldCard.reference);
      hasWrites = true;
    }

    // Copy the current cards into the public snapshot.
    for (final privateCard in privateCardsSnapshot.docs) {
      final data = privateCard.data();

      final publicCardRef = publicSetRef
          .collection('studyCards')
          .doc(privateCard.id);

      batch.set(publicCardRef, {
        'question': data['question'] as String? ?? '',
        'answer': data['answer'] as String? ?? '',
      });

      hasWrites = true;
    }

    if (hasWrites) {
      await batch.commit();
    }
  }

  Future<void> _deletePublicSnapshot(String setId) async {
    final userId = _currentUser.uid;

    final publicSetRef = _publicSetReference(userId, setId);

    final publicSetSnapshot = await publicSetRef.get();

    if (!publicSetSnapshot.exists) {
      return;
    }

    final cardsSnapshot = await publicSetRef.collection('studyCards').get();

    final batch = _firestore.batch();

    for (final card in cardsSnapshot.docs) {
      batch.delete(card.reference);
    }

    batch.delete(publicSetRef);

    await batch.commit();
  }

  // ============================================================
  // READ EXPLORE
  // ============================================================

  Future<List<StudyCardSet>> getPublicStudyCardSets() async {
    final snapshot = await _publicSets.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return StudyCardSet(
        id: doc.id,
        title: data['title'] as String? ?? '',
        description: data['description'] as String? ?? '',
        isPublic: true,
      );
    }).toList();
  }

  Future<List<StudyCard>> getPublicCards(String publicSetId) async {
    final snapshot = await _publicSets
        .doc(publicSetId)
        .collection('studyCards')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return StudyCard(
        id: doc.id,
        question: data['question'] as String? ?? '',
        answer: data['answer'] as String? ?? '',
      );
    }).toList();
  }

  // ============================================================
  // COPY PUBLIC SET INTO MY SETS
  // ============================================================

  /// Makes a completely independent private copy.
  ///
  /// Later changes to the public/original set will NOT affect this copy.
  Future<void> copyPublicSetToMySets(String publicSetId) async {
    final publicSetRef = _publicSets.doc(publicSetId);

    final publicSetSnapshot = await publicSetRef.get();

    if (!publicSetSnapshot.exists) {
      throw Exception('Das öffentliche Lernkartenset existiert nicht mehr.');
    }

    final publicSetData = publicSetSnapshot.data()!;

    final publicCardsSnapshot = await publicSetRef
        .collection('studyCards')
        .get();

    // IMPORTANT:
    // A completely NEW document is created in the current user's area.
    final newPrivateSetRef = _sets.doc();

    final batch = _firestore.batch();

    batch.set(newPrivateSetRef, {
      'title': publicSetData['title'] as String? ?? '',
      'description': publicSetData['description'] as String? ?? '',

      // Copied sets are private by default.
      'isPublic': false,
    });

    // Also create completely NEW card documents.
    for (final publicCard in publicCardsSnapshot.docs) {
      final cardData = publicCard.data();

      final newPrivateCardRef = newPrivateSetRef.collection('studyCards').doc();

      batch.set(newPrivateCardRef, {
        'question': cardData['question'] as String? ?? '',
        'answer': cardData['answer'] as String? ?? '',
      });
    }

    await batch.commit();
  }
}
