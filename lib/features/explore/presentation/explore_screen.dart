import 'package:flutter/material.dart';

import '../../study_card/data/study_card_repository.dart';
import '../../study_card/domain/study_card_set.dart';
import 'public_study_card_set_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final StudyCardRepository repository = StudyCardRepository();

  late Future<List<StudyCardSet>> setsFuture;

  @override
  void initState() {
    super.initState();

    setsFuture = repository.getPublicStudyCardSets();
  }

  void _reloadSets() {
    setState(() {
      setsFuture = repository.getPublicStudyCardSets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entdecken'), centerTitle: true),

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
                      'Die öffentlichen Lernkartensets konnten '
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
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.explore_outlined, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Noch keine öffentlichen '
                      'Lernkartensets vorhanden.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _reloadSets();
              await setsFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sets.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                final studyCardSet = sets[index];

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.public,
                      color: Colors.deepPurple.shade400,
                    ),

                    title: Text(studyCardSet.title),

                    subtitle: Text(studyCardSet.description),

                    trailing: const Icon(Icons.chevron_right),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PublicStudyCardSetDetailScreen(
                            studyCardSet: studyCardSet,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
