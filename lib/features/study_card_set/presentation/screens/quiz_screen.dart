import 'package:flutter/material.dart';
import '../../domain/study_card.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final List<StudyCard> cards;

  const QuizScreen({super.key, required this.title, required this.cards});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController answerController = TextEditingController();

  int currentIndex = 0;
  int correctAnswers = 0;

  bool answerChecked = false;
  bool currentAnswerCorrect = false;
  bool quizFinished = false;
  bool _allowPop = false;

  StudyCard get currentCard => widget.cards[currentIndex];

  Future<void> _confirmLeaveQuiz() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz verlassen?'),
          content: const Text(
            'Möchtest du das Quiz wirklich verlassen? '
            'Dein aktueller Fortschritt geht verloren.',
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
              child: const Text('Verlassen'),
            ),
          ],
        );
      },
    );

    if (shouldLeave == true && mounted) {
      setState(() {
        _allowPop = true;
      });

      Navigator.of(context).pop();
    }
  }

  void _checkAnswer() {
    if (answerChecked) {
      return;
    }

    final userAnswer = _normalize(answerController.text);

    final correctAnswer = _normalize(currentCard.answer);

    final isCorrect = userAnswer.isNotEmpty && userAnswer == correctAnswer;

    setState(() {
      answerChecked = true;
      currentAnswerCorrect = isCorrect;

      if (isCorrect) {
        correctAnswers++;
      }
    });
  }

  String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  void _nextQuestion() {
    if (currentIndex >= widget.cards.length - 1) {
      setState(() {
        quizFinished = true;
      });

      return;
    }

    setState(() {
      currentIndex++;
      answerController.clear();
      answerChecked = false;
      currentAnswerCorrect = false;
    });
  }

  void _restartQuiz() {
    setState(() {
      currentIndex = 0;
      correctAnswers = 0;
      answerController.clear();
      answerChecked = false;
      currentAnswerCorrect = false;
      quizFinished = false;
    });
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: quizFinished || _allowPop,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        if (!quizFinished) {
          await _confirmLeaveQuiz();
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.title} – Quiz'),
          centerTitle: true,
        ),

        body: quizFinished ? _buildResult() : _buildQuestion(),
      ),
    );
  }

  Widget _buildQuestion() {
    final progress =
        (currentIndex + (answerChecked ? 1 : 0)) / widget.cards.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Frage ${currentIndex + 1} '
                'von ${widget.cards.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              Text(
                '$correctAnswers richtig',
                style: TextStyle(color: Colors.deepPurple.shade400),
              ),
            ],
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(20),
          ),

          const SizedBox(height: 32),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              children: [
                const Text(
                  'FRAGE',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                Text(
                  currentCard.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ANSWER INPUT
          TextField(
            controller: answerController,
            enabled: !answerChecked,

            textInputAction: TextInputAction.done,

            onSubmitted: (_) {
              if (!answerChecked) {
                _checkAnswer();
              }
            },

            decoration: const InputDecoration(
              labelText: 'Deine Antwort',
              hintText: 'Antwort eingeben...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          if (!answerChecked)
            FilledButton.icon(
              onPressed: _checkAnswer,
              icon: const Icon(Icons.check),
              label: const Text('Antwort prüfen'),
            ),

          if (answerChecked) ...[
            _buildAnswerFeedback(),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _nextQuestion,

              icon: Icon(
                currentIndex == widget.cards.length - 1
                    ? Icons.flag_outlined
                    : Icons.arrow_forward,
              ),

              label: Text(
                currentIndex == widget.cards.length - 1
                    ? 'Auswertung anzeigen'
                    : 'Nächste Frage',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerFeedback() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: currentAnswerCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: currentAnswerCorrect
              ? Colors.green.shade300
              : Colors.red.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                currentAnswerCorrect ? Icons.check_circle : Icons.cancel,
                color: currentAnswerCorrect ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                currentAnswerCorrect ? 'Richtig!' : 'Leider falsch',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: currentAnswerCorrect
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ],
          ),

          if (!currentAnswerCorrect) ...[
            const SizedBox(height: 16),

            const Text(
              'Richtige Antwort:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 4),

            Text(
              currentCard.answer,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResult() {
    final total = widget.cards.length;
    final percentage = total == 0
        ? 0
        : ((correctAnswers / total) * 100).round();

    String evaluation;

    if (percentage >= 90) {
      evaluation = 'Perfekt!';
    } else if (percentage >= 75) {
      evaluation = 'Sehr gut!';
    } else if (percentage >= 60) {
      evaluation = 'Gut gemacht!';
    } else if (percentage >= 40) {
      evaluation = 'Weiter üben!';
    } else {
      evaluation = 'Noch etwas Übung nötig.';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            const Text(
              'Quiz abgeschlossen',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [
                  Text(
                    '$correctAnswers / $total',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),
                  const Text('richtige Antworten'),
                  const SizedBox(height: 24),

                  Text(
                    '$percentage %',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    evaluation,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _restartQuiz,
                icon: const Icon(Icons.refresh),
                label: const Text('Quiz erneut starten'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Zurück zum Lernkartenset'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
