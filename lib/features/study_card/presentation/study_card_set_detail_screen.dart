import 'package:flip_card_plus/flip_card_plus.dart';
import 'package:flutter/material.dart';
import '../domain/study_card_set.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class StudyCardListScreen extends StatelessWidget {
  final StudyCardSet studyCardSet;

  const StudyCardListScreen({super.key, required this.studyCardSet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(studyCardSet.title), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studyCardSet.description),
                const SizedBox(height: 6),
                Text(
                  '${studyCardSet.studyCards.length} Karten',
                  style: TextStyle(color: Colors.deepPurple.shade400),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: studyCardSet.studyCards.length,
              itemBuilder: (context, index) {
                final card = studyCardSet.studyCards[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Slidable(
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.42,
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) {
                            print('Bearbeiten');
                          },
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFF8B7AB8),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                            print('Löschen');
                          },
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFFD48787),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline_rounded, size: 25),
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
                      front: _cardSide(label: 'FRAGE', text: card.title),
                      back: _cardSide(label: 'ANTWORT', text: card.description),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardSide({required String label, required String text}) {
    return Container(
      height: 180,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
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
