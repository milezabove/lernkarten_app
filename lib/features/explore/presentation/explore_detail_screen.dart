import 'package:flip_card_plus/flip_card_plus.dart';
import 'package:flutter/material.dart';

import '../../study_card_set/data/study_card_repository.dart';
import '../../study_card_set/domain/study_card.dart';
import '../../study_card_set/domain/study_card_set.dart';

class ExploreDetailScreen extends StatefulWidget {
  final StudyCardSet studyCardSet;

  const ExploreDetailScreen({super.key, required this.studyCardSet});

  @override
  State<ExploreDetailScreen> createState() => _ExploreDetailScreenState();
}

class _ExploreDetailScreenState extends State<ExploreDetailScreen> {
  final StudyCardRepository repository = StudyCardRepository();

  late Future<List<StudyCard>> cardsFuture;

  bool isCopying = false;
  bool wasCopied = false;

  @override
  void initState() {
    super.initState();

    cardsFuture = repository.getPublicCards(widget.studyCardSet.id);
  }

  void _reloadCards() {
    setState(() {
      cardsFuture = repository.getPublicCards(widget.studyCardSet.id);
    });
  }

  Future<void> _copyToMySets() async {
    if (isCopying || wasCopied) {
      return;
    }

    setState(() {
      isCopying = true;
    });

    try {
      await repository.copyPublicSetToMySets(widget.studyCardSet.id);

      if (!mounted) {
        return;
      }

      setState(() {
        wasCopied = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Das Lernkartenset wurde zu deinen Sets hinzugefügt.'),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Serverseitiger Fehler beim Hinzufügen. Probiere es später erneut.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCopying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.studyCardSet.title), centerTitle: true),

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
                      '${cards.length} '
                      '${cards.length == 1 ? 'Karte' : 'Karten'}',
                      style: TextStyle(color: Colors.deepPurple.shade400),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isCopying || wasCopied
                            ? null
                            : _copyToMySets,

                        icon: isCopying
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(wasCopied ? Icons.check : Icons.add),

                        label: Text(
                          isCopying
                              ? 'Wird hinzugefügt...'
                              : wasCopied
                              ? 'Zu meinen Sets hinzugefügt'
                              : 'Zu meinen Sets hinzufügen',
                        ),
                      ),
                    ),
                  ],
                ),
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

                            // Important:
                            // no Slidable here.
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
