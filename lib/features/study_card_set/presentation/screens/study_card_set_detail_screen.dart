import 'package:flutter/material.dart';
import '../../data/study_card_repository.dart';
import '../../domain/study_card.dart';
import '../../domain/study_card_set.dart';
import 'quiz_screen.dart';
import 'study_card_form_screen.dart';
import '../widgets/study_card_set_header.dart';
import '../widgets/study_card_tile.dart';

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
      MaterialPageRoute(builder: (_) => const StudyCardFormScreen()),
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
      _showError(
        'Serverseitiger Fehler beim Erstellen. Probiere es später erneut.',
      );
    }
  }

  Future<void> _editCard(StudyCard card) async {
    final updatedCard = await Navigator.push<StudyCard>(
      context,
      MaterialPageRoute(builder: (_) => StudyCardFormScreen(studyCard: card)),
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
      _showError(
        'Serverseitiger Fehler beim Bearbeiten. Probiere es später erneut.',
      );
    }
  }

  Future<void> _deleteCard(StudyCard card) async {
    final confirmed = await _showDeleteDialog(card);

    if (!confirmed) {
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
      _showError(
        'Serverseitiger Fehler beim Löschen. Probiere es später erneut.',
      );
    }
  }

  Future<bool> _showDeleteDialog(StudyCard card) async {
    final result = await showDialog<bool>(
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

    return result ?? false;
  }

  void _startQuiz(List<StudyCard> cards) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            QuizScreen(title: widget.studyCardSet.title, cards: cards),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
            children: [
              StudyCardSetHeader(
                studyCardSet: widget.studyCardSet,

                cardCount: cards.length,

                onStartQuiz: cards.isEmpty
                    ? null
                    : () {
                        _startQuiz(cards);
                      },
              ),

              const Divider(),

              Expanded(
                child: cards.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.style_outlined, size: 60),
                              SizedBox(height: 16),
                              Text(
                                'Dieses Set enthält '
                                'noch keine '
                                'Lernkarten.',
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

                          return StudyCardTile(
                            card: card,

                            onEdit: () {
                              _editCard(card);
                            },

                            onDelete: () {
                              _deleteCard(card);
                            },
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
}
