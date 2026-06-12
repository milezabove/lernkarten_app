import 'study_card.dart';

class StudyCardSet {
  final String title;
  final String description;
  final List<StudyCard> studyCards;
  final bool isPublic;

  const StudyCardSet({
    required this.title,
    required this.description,
    required this.studyCards,
    required this.isPublic,
  });
}
