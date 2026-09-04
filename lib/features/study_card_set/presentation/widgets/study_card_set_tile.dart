import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../domain/study_card_set.dart';

class StudyCardSetTile extends StatelessWidget {
  final StudyCardSet studyCardSet;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isBusy;
  final bool writeLocked;

  const StudyCardSetTile({
    super.key,
    required this.studyCardSet,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.isBusy = false,
    this.writeLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Slidable(
        key: ValueKey(studyCardSet.id),

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
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
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
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),

        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(12),
          ),

          child: ListTile(
            leading: Icon(
              studyCardSet.isPublic ? Icons.public : Icons.lock_outline,
              color: Colors.deepPurple.shade400,
            ),

            title: Text(studyCardSet.title),
            subtitle: Text(studyCardSet.description),
            trailing: isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),

            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
