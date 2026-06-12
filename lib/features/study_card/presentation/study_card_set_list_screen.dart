import 'package:flutter/material.dart';
import '../data/study_card_mock_data.dart';
import '../domain/study_card_set.dart';
import 'study_card_set_detail_screen.dart';

class StudyCardSetListScreen extends StatelessWidget {
  const StudyCardSetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Sets'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: studyCardSets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final StudyCardSet studyCardSet = studyCardSets[index];
          return ListTile(
            tileColor: Colors.deepPurple.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
          );
        },
      ),
    );
  }
}
