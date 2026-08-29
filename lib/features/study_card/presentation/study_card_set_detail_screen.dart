import 'package:flip_card_plus/flip_card_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../data/study_card_repository.dart';
import '../domain/study_card.dart';
import '../domain/study_card_set.dart';
import 'study_card_form_screen.dart';

class StudyCardListScreen extends StatefulWidget {
  final StudyCardSet studyCardSet;

  const StudyCardListScreen({super.key, required this.studyCardSet});

  @override
  State<StudyCardListScreen> createState() => _StudyCardListScreenState();
}

class _StudyCardListScreenState extends State<StudyCardListScreen> {
  final StudyCardRepository repository = StudyCardRepository();

  late Future<List<StudyCard>> cardsFuture;

  @override
  void initState() {
    super.initState();

    cardsFuture = repository.getCards(widget.studyCardSet.id);
  }

  void _reloadCards() {
    setState(() {
      cardsFuture = repository.getCards(widget.studyCardSet.id);
    });
  }

  Future<void> _createCard() async {
    final newCard = await Navigator.push<StudyCard>(
      context,
      MaterialPageRoute(builder: (context) => const StudyCardFormScreen()),
    );

    if (newCard == null) {
      return;
    }

    try {
      await repository.createCard(widget.studyCardSet.id, newCard);

      if (!mounted) {
        return;
      }

      _reloadCards();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkarte wurde erstellt.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Erstellen: $error')));
    }
  }

  Future<void> _editCard(StudyCard card) async {
    final updatedCard = await Navigator.push<StudyCard>(
      context,
      MaterialPageRoute(
        builder: (context) => StudyCardFormScreen(studyCard: card),
      ),
    );

    if (updatedCard == null) {
      return;
    }

    try {
      await repository.updateCard(widget.studyCardSet.id, updatedCard);

      if (!mounted) {
        return;
      }

      _reloadCards();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkarte wurde aktualisiert.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Bearbeiten: $error')));
    }
  }

  Future<void> _deleteCard(StudyCard card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lernkarte löschen?'),
          content: Text(
            'Möchtest du "${card.question}" '
            'wirklich löschen?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Löschen'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await repository.deleteCard(widget.studyCardSet.id, card.id);

      if (!mounted) {
        return;
      }

      _reloadCards();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkarte wurde gelöscht.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Löschen: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.studyCardSet.title), centerTitle: true),

      floatingActionButton: FloatingActionButton(
        onPressed: _createCard,
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<StudyCard>>(
        future: cardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Die Lernkarten konnten '
                      'nicht geladen werden.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _reloadCards,
                      child: const Text('Erneut versuchen'),
                    ),
                  ],
                ),
              ),
            );
          }

          final cards = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.studyCardSet.description),
                    const SizedBox(height: 6),
                    Text(
                      '${cards.length} Karten',
                      style: TextStyle(color: Colors.deepPurple.shade400),
                    ),
                  ],
                ),
              ),

              const Divider(),

              Expanded(
                child: cards.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.style_outlined, size: 60),
                              const SizedBox(height: 16),
                              const Text(
                                'Dieses Set enthält '
                                'noch keine Lernkarten.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Slidable(
                                key: ValueKey(card.id),

                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.42,
                                  children: [
                                    CustomSlidableAction(
                                      onPressed: (context) {
                                        _editCard(card);
                                      },
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: const Color(0xFF8B7AB8),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.edit_outlined, size: 25),
                                          SizedBox(height: 6),
                                          Text(
                                            'Bearbeiten',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustomSlidableAction(
                                      onPressed: (context) {
                                        _deleteCard(card);
                                      },
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: const Color(0xFFD48787),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete_outline_rounded,
                                            size: 25,
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            'Löschen',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                child: FlipCardPlus(
                                  direction: Axis.horizontal,
                                  front: _cardSide(
                                    label: 'FRAGE',
                                    text: card.question,
                                  ),
                                  back: _cardSide(
                                    label: 'ANTWORT',
                                    text: card.answer,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cardSide({required String label, required String text}) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade200,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_outlined, size: 16, color: Colors.black45),
              SizedBox(width: 6),
              Text(
                'Tippen zum Umdrehen',
                style: TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
