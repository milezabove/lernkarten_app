import 'package:flutter/material.dart';
import '../domain/study_card_set.dart';

class StudyCardSetFormScreen extends StatefulWidget {
  final StudyCardSet? studyCardSet;

  const StudyCardSetFormScreen({super.key, this.studyCardSet});

  @override
  State<StudyCardSetFormScreen> createState() => _StudyCardSetFormScreenState();
}

class _StudyCardSetFormScreenState extends State<StudyCardSetFormScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  late bool isPublic;

  bool get isEditing => widget.studyCardSet != null;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.studyCardSet?.title ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.studyCardSet?.description ?? '',
    );

    isPublic = widget.studyCardSet?.isPublic ?? false;
  }

  void _save() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final studyCardSet = StudyCardSet(
      id: widget.studyCardSet?.id ?? '',
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      isPublic: isPublic,
      studyCards: widget.studyCardSet?.studyCards ?? const [],
    );

    Navigator.pop(context, studyCardSet);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Lernkartenset bearbeiten' : 'Neues Lernkartenset',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                maxLength: 20,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  border: OutlineInputBorder(),
                  hintText: 'Titel des Sets',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Bitte einen Titel eingeben.';
                  }

                  if (value.trim().length > 20) {
                    return 'Der Titel darf maximal 20 Zeichen haben.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLength: 50,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(),
                  hintText: 'Kurze Beschreibung',
                ),
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Öffentlich'),
                subtitle: const Text(
                  'Andere Benutzer dürfen dieses Set sehen.',
                ),
                value: isPublic,
                onChanged: (value) {
                  setState(() {
                    isPublic = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(
                    isEditing ? 'Änderungen speichern' : 'Set erstellen',
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
