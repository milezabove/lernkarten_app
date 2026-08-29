import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../data/study_card_repository.dart';
import '../domain/study_card_set.dart';
import 'study_card_set_detail_screen.dart';
import 'study_card_set_form_screen.dart';

class StudyCardSetListScreen extends StatefulWidget {
  const StudyCardSetListScreen({super.key});

  @override
  State<StudyCardSetListScreen> createState() => _StudyCardSetListScreenState();
}

class _StudyCardSetListScreenState extends State<StudyCardSetListScreen> {
  final StudyCardRepository repository = StudyCardRepository();

  late Future<List<StudyCardSet>> setsFuture;

  @override
  void initState() {
    super.initState();
    setsFuture = repository.getStudyCardSets();
  }

  void _reloadSets() {
    setState(() {
      setsFuture = repository.getStudyCardSets();
    });
  }

  Future<void> _createSet() async {
    final newSet = await Navigator.push<StudyCardSet>(
      context,
      MaterialPageRoute(builder: (context) => const StudyCardSetFormScreen()),
    );

    if (newSet == null) {
      return;
    }

    try {
      await repository.createStudyCardSet(newSet);

      if (!mounted) {
        return;
      }

      _reloadSets();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkartenset wurde erstellt.')),
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

  Future<void> _editSet(StudyCardSet studyCardSet) async {
    final updatedSet = await Navigator.push<StudyCardSet>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StudyCardSetFormScreen(studyCardSet: studyCardSet),
      ),
    );

    if (updatedSet == null) {
      return;
    }

    try {
      await repository.updateStudyCardSet(updatedSet);

      if (!mounted) {
        return;
      }

      _reloadSets();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkartenset wurde aktualisiert.')),
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

  Future<void> _deleteSet(StudyCardSet studyCardSet) async {
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

    if (confirmed != true) {
      return;
    }

    try {
      await repository.deleteStudyCardSet(studyCardSet.id);

      if (!mounted) {
        return;
      }

      _reloadSets();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lernkartenset wurde gelöscht.')),
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
      appBar: AppBar(title: const Text('Meine Sets'), centerTitle: true),

      // CREATE
      floatingActionButton: FloatingActionButton(
        onPressed: _createSet,
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<StudyCardSet>>(
        future: setsFuture,
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
                      'Die Lernkartensets konnten '
                      'nicht geladen werden.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _reloadSets,
                      child: const Text('Erneut versuchen'),
                    ),
                  ],
                ),
              ),
            );
          }

          final sets = snapshot.data ?? [];

          if (sets.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.folder_copy_outlined, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      'Noch keine Lernkartensets '
                      'vorhanden.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Erstelle dein erstes Set.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _createSet,
                      icon: const Icon(Icons.add),
                      label: const Text('Set erstellen'),
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

              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Slidable(
                  key: ValueKey(studyCardSet.id),

                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.42,
                    children: [
                      CustomSlidableAction(
                        onPressed: (context) {
                          _editSet(studyCardSet);
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
                          _deleteSet(studyCardSet);
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

                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      tileColor: Colors.transparent,

                      leading: const Icon(Icons.style_outlined),

                      title: Text(studyCardSet.title),

                      subtitle: Text(studyCardSet.description),

                      trailing: const Icon(Icons.chevron_right),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudyCardListScreen(studyCardSet: studyCardSet),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
