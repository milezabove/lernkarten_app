import 'package:flutter/material.dart';

import '../../domain/study_card_set.dart';

class StudyCardSetHeader extends StatelessWidget {
  final StudyCardSet studyCardSet;
  final int cardCount;
  final VoidCallback? onStartQuiz;

  const StudyCardSetHeader({
    super.key,
    required this.studyCardSet,
    required this.cardCount,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(studyCardSet.description),

          const SizedBox(height: 6),

          Text(
            '$cardCount '
            '${cardCount == 1 ? 'Karte' : 'Karten'}',

            style: TextStyle(color: Colors.deepPurple.shade400),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,

            child: FilledButton.icon(
              onPressed: onStartQuiz,

              icon: const Icon(Icons.quiz_outlined),

              label: const Text('Quiz starten'),
            ),
          ),
        ],
      ),
    );
  }
}
