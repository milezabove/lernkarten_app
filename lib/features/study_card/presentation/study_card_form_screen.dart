import 'package:flutter/material.dart';

import '../domain/study_card.dart';

class StudyCardFormScreen extends StatefulWidget {
  final StudyCard? studyCard;

  const StudyCardFormScreen({super.key, this.studyCard});

  @override
  State<StudyCardFormScreen> createState() => _StudyCardFormScreenState();
}

class _StudyCardFormScreenState extends State<StudyCardFormScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController questionController;
  late final TextEditingController answerController;

  bool get isEditing => widget.studyCard != null;

  @override
  void initState() {
    super.initState();

    questionController = TextEditingController(
      text: widget.studyCard?.question ?? '',
    );

    answerController = TextEditingController(
      text: widget.studyCard?.answer ?? '',
    );
  }

  void _saveCard() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final card = StudyCard(
      id: widget.studyCard?.id ?? '',
      question: questionController.text.trim(),
      answer: answerController.text.trim(),
    );

    Navigator.pop(context, card);
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Lernkarte bearbeiten' : 'Neue Lernkarte'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: questionController,
                maxLength: 80,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Frage',
                  border: OutlineInputBorder(),
                  hintText: 'Frage eingeben',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Bitte eine Frage eingeben.';
                  }

                  if (value.trim().length > 80) {
                    return 'Die Frage darf maximal 80 Zeichen haben.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: answerController,
                maxLength: 80,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Antwort',
                  border: OutlineInputBorder(),
                  hintText: 'Antwort eingeben',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Bitte eine Antwort eingeben.';
                  }

                  if (value.trim().length > 80) {
                    return 'Die Antwort darf maximal 80 Zeichen haben.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCard,
                  child: Text(
                    isEditing ? 'Änderungen speichern' : 'Lernkarte erstellen',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
