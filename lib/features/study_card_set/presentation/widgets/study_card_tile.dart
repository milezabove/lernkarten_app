import 'package:flip_card_plus/flip_card_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../domain/study_card.dart';
import 'study_card_side.dart';

class StudyCardTile extends StatelessWidget {
  final StudyCard card;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isBusy;
  final bool writeLocked;

  const StudyCardTile({
    super.key,
    required this.card,
    required this.onEdit,
    required this.onDelete,
    this.isBusy = false,
    this.writeLocked = false,
  });

  @override
  Widget build(BuildContext context) {
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
                onPressed: writeLocked ? null : (_) => onEdit(),
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
                onPressed: writeLocked ? null : (_) => onDelete(),
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

          child: isBusy
              ? Container(
                  height: 180,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: Colors.deepPurple.shade100,
                  child: const CircularProgressIndicator(),
                )
              : FlipCardPlus(
                  direction: Axis.horizontal,
                  front: StudyCardSide(label: 'FRAGE', text: card.question),
                  back: StudyCardSide(label: 'ANTWORT', text: card.answer),
                ),
        ),
      ),
    );
  }
}
