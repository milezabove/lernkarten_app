import '../domain/study_card.dart';
import '../domain/study_card_set.dart';

final studyCardSets = const [
  StudyCardSet(
    title: 'Französisch',
    description: 'Französisch Vokabeln Kapitel 1-5',
    studyCards: [
      StudyCard(title: 'Das Auto', description: 'La voiture'),
      StudyCard(title: 'Das Haus', description: 'La maison'),
      StudyCard(title: 'Der Computer', description: 'L\'ordinateur'),
      StudyCard(title: 'Mein Bruder', description: 'Mon frère'),
      StudyCard(title: 'Sein Vater', description: 'Son père'),
      StudyCard(title: 'Unser Hund', description: 'Notre chien'),
    ],
    isPublic: false,
  ),
  StudyCardSet(
    title: 'Spanisch',
    description: 'Spanisch Vokabeln Kapitel 3',
    studyCards: [
      StudyCard(title: 'Meine Schwester', description: 'Mi hermana'),
      StudyCard(title: 'Wie geht es dir?', description: '¿Cómo estás?'),
      StudyCard(title: 'Die Schule', description: 'La escuela'),
    ],
    isPublic: false,
  ),
  StudyCardSet(
    title: 'Englisch',
    description: 'Englisch Vokabeln Kapitel 2',
    studyCards: [
      StudyCard(title: 'Das Buch', description: 'The book'),
      StudyCard(title: 'Der Stuhl', description: 'The chair'),
    ],
    isPublic: false,
  ),
];
