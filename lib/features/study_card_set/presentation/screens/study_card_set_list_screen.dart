import 'package:flutter/material.dart';

import '../../data/study_card_repository.dart';
import '../../domain/study_card_set.dart';
import '../widgets/study_card_set_tile.dart';
import 'study_card_set_detail_screen.dart';
import 'study_card_set_form_screen.dart';

class StudyCardSetListScreen extends StatefulWidget {
  const StudyCardSetListScreen({super.key});

  @override
  State<StudyCardSetListScreen> createState() => _StudyCardSetListScreenState();
}

class _StudyCardSetListScreenState extends State<StudyCardSetListScreen> {
  final StudyCardRepository repository = StudyCardRepository();

  bool isCreatingSet = false;
  String? busySetId;
  bool get isWriting => isCreatingSet || busySetId != null;

  Future<void> _createSet() async {
    if (isWriting) {
      return;
    }

    final newSet = await Navigator.push<StudyCardSet>(
      context,
      MaterialPageRoute(builder: (context) => const StudyCardSetFormScreen()),
    );

    if (newSet == null || !mounted) {
      return;
    }

    setState(() {
      isCreatingSet = true;
    });

    try {
      await repository.createStudyCardSet(newSet);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkartenset wurde erstellt.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Serverseitiger Fehler beim Erstellen. '
            'Probiere es später erneut.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCreatingSet = false;
        });
      }
    }
  }

  Future<void> _editSet(StudyCardSet studyCardSet) async {
    if (isWriting) {
      return;
    }

    final updatedSet = await Navigator.push<StudyCardSet>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StudyCardSetFormScreen(studyCardSet: studyCardSet),
      ),
    );

    if (updatedSet == null || !mounted) {
      return;
    }

    setState(() {
      busySetId = studyCardSet.id;
    });

    try {
      await repository.updateStudyCardSet(updatedSet);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkartenset wurde aktualisiert.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Serverseitiger Fehler beim Bearbeiten. '
            'Probiere es später erneut.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          busySetId = null;
        });
      }
    }
  }

  Future<void> _deleteSet(StudyCardSet studyCardSet) async {
    if (isWriting) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lernkartenset löschen?'),
          content: Text(
            'Möchtest du "${studyCardSet.title}" '
            'wirklich löschen?\n\n'
            'Alle Lernkarten in diesem Set '
            'werden ebenfalls gelöscht.',
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

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      busySetId = studyCardSet.id;
    });

    try {
      await repository.deleteStudyCardSet(studyCardSet.id);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkartenset wurde gelöscht.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Serverseitiger Fehler beim Löschen. '
            'Probiere es später erneut.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          busySetId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Sets'), centerTitle: true),

      floatingActionButton: FloatingActionButton(
        onPressed: isWriting ? null : _createSet,

        child: isCreatingSet
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
      ),

      body: StreamBuilder<List<StudyCardSet>>(
        stream: repository.watchStudyCardSets(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Die Lernkartensets konnten '
                      'nicht geladen werden.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final sets = snapshot.data ?? [];

          if (sets.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder_copy_outlined, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Noch keine Lernkartensets '
                      'vorhanden.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),

            itemCount: sets.length,

            separatorBuilder: (context, index) => const SizedBox(height: 10),

            itemBuilder: (context, index) {
              final studyCardSet = sets[index];

              return StudyCardSetTile(
                studyCardSet: studyCardSet,

                isBusy: busySetId == studyCardSet.id,

                writeLocked: isWriting,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudyCardListScreen(studyCardSet: studyCardSet),
                    ),
                  );
                },

                onEdit: () {
                  _editSet(studyCardSet);
                },

                onDelete: () {
                  _deleteSet(studyCardSet);
                },
              );
            },
          );
        },
      ),
    );
  }
}
