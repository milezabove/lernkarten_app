import 'study_card.dart';

class StudyCardSet {
  final String id;
  final String title;
  final String description;
  final List<StudyCard> studyCards;
  final bool isPublic;

  const StudyCardSet({
    this.id = '',
    required this.title,
    required this.description,
    this.studyCards = const [],
    required this.isPublic,
  });
}
