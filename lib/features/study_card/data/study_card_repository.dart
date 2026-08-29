import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/study_card.dart';
import '../domain/study_card_set.dart';

class StudyCardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _sets {
    return _firestore.collection('studyCardSets');
  }

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

  Future<void> createStudyCardSet(StudyCardSet studyCardSet) async {
    await _sets.add({
      'title': studyCardSet.title,
      'description': studyCardSet.description,
      'isPublic': studyCardSet.isPublic,
    });
  }

  Future<void> updateStudyCardSet(StudyCardSet studyCardSet) async {
    await _sets.doc(studyCardSet.id).update({
      'title': studyCardSet.title,
      'description': studyCardSet.description,
      'isPublic': studyCardSet.isPublic,
    });
  }

  Future<void> deleteStudyCardSet(String setId) async {
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
  }

  Future<void> updateCard(String setId, StudyCard card) async {
    await _sets.doc(setId).collection('studyCards').doc(card.id).update({
      'question': card.question,
      'answer': card.answer,
    });
  }

  Future<void> deleteCard(String setId, String cardId) async {
    await _sets.doc(setId).collection('studyCards').doc(cardId).delete();
  }
}
