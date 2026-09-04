import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Über die App'),
            const SizedBox(height: 12),

            Text(
              'Die Lernkarten-App hilft dir dabei, eigene Lernsets '
              'zu erstellen, Lernkarten zu verwalten, Wissen mit '
              'Quizfragen zu testen und öffentliche Sets anderer '
              'Benutzer zu entdecken.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 32),

            _sectionTitle('Funktionen'),

            const SizedBox(height: 16),

            _infoTile(
              icon: Icons.style_outlined,
              title: 'Lernkarten',
              text:
                  'Eigene Lernsets und Karten erstellen, '
                  'bearbeiten und löschen.',
            ),

            const SizedBox(height: 12),

            _infoTile(
              icon: Icons.quiz_outlined,
              title: 'Quizmodus',
              text:
                  'Alle Karten eines Sets als Quiz durchgehen '
                  'und am Ende eine Auswertung erhalten.',
            ),

            const SizedBox(height: 12),

            _infoTile(
              icon: Icons.public_outlined,
              title: 'Öffentliche Sets',
              text:
                  'Öffentliche Lernsets anderer Benutzer '
                  'entdecken und ansehen.',
            ),

            const SizedBox(height: 12),

            _infoTile(
              icon: Icons.copy_outlined,
              title: 'Sets übernehmen',
              text:
                  'Ein öffentliches Set kann als eigene '
                  'private Kopie zu deinen Sets hinzugefügt werden.',
            ),

            const SizedBox(height: 32),

            _sectionTitle('So funktioniert\'s'),

            const SizedBox(height: 16),

            _stepTile(
              number: 1,
              title: 'Lernset erstellen',
              text:
                  'Öffne „Meine Sets“ und tippe auf das Plus, '
                  'um ein neues Lernkartenset zu erstellen.',
            ),

            const SizedBox(height: 12),

            _stepTile(
              number: 2,
              title: 'Lernkarten hinzufügen',
              text:
                  'Öffne dein Set und füge Fragen und Antworten '
                  'über den Plus-Button hinzu.',
            ),

            const SizedBox(height: 12),

            _stepTile(
              number: 3,
              title: 'Lernen',
              text:
                  'Tippe auf eine Karte, um sie umzudrehen und '
                  'die Antwort anzuzeigen.',
            ),

            const SizedBox(height: 12),

            _stepTile(
              number: 4,
              title: 'Quiz starten',
              text:
                  'Mit „Quiz starten“ wirst du durch alle Karten '
                  'des Sets geführt und erhältst am Ende dein Ergebnis.',
            ),

            const SizedBox(height: 12),

            _stepTile(
              number: 5,
              title: 'Sets entdecken',
              text:
                  'Im Bereich „Entdecken“ findest du öffentliche '
                  'Lernsets und kannst sie zu deinen eigenen Sets kopieren.',
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  static Widget _infoTile({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple.shade400, size: 26),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _stepTile({
    required int number,
    required String title,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.deepPurple.shade100,
          child: Text(
            '$number',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
