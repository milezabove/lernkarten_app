# Lernkarten-App

Die Lernkarten-App ist eine Flutter-App zum Erstellen und Verwalten von Lernkartensets und Lernkarten.


## 1. Welche Daten werden in Firebase gespeichert?

Die Daten werden im Firebase Firestore gespeichert.

Es gibt eine Collection `studyCardSets`. Jedes Dokument darin stellt ein Lernkartenset dar und enthält:

- `id`: ID des Lernkartensets, wird automatisch generiert
- `title`: Titel des Lernkartensets
- `description`: Beschreibung des Lernkartensets
- `isPublic`: Gibt an, ob das Lernkartenset öffentlich ist

Zu jedem Lernkartenset gehört eine Subcollection `studyCards`. Darin werden die einzelnen Lernkarten gespeichert. Eine Lernkarte enthält:

- `id`: ID der Lernkarte, wird automatisch generiert
- `question`: Frage (Vorderseite der Lernkarte)
- `answer`: Antwort (Rückseite der Lernkarte)

---

## 2. Wo sind Create, Read, Update und Delete umgesetzt?

Die CRUD-Funktionen sind hauptsächlich im `StudyCardRepository` umgesetzt. 
Die Screens rufen diese Methoden auf und stellen die Funktionen für die Benutzeroberfläche bereit.

### Zentrale Firebase-Anbindung

Die Datei `lib/features/study_card/data/study_card_repository.dart` enthält die Zugriffe auf Cloud Firestore.

#### Lernkartensets

- Create: `createStudyCardSet()`
- Read: `getStudyCardSets()`
- Update: `updateStudyCardSet()`
- Delete: `deleteStudyCardSet()`

Die Daten werden dabei in der Firestore-Collection `studyCardSets` gespeichert.

#### Lernkarten

- Create: `createCard()`
- Read: `getCards()`
- Update: `updateCard()`
- Delete: `deleteCard()`

Die Lernkarten werden jeweils in der Subcollection `studyCards` des entsprechenden Lernkartensets gespeichert.

---

### CRUD für Lernkartensets in der Benutzeroberfläche

Im Screen `lib/features/study_card/presentation/study_card_set_list_screen.dart` werden die Lernkartensets angezeigt und verwaltet.

- Create: `_createSet()`
  - Über den Floating Action Button wird das Formular zum Erstellen eines neuen Sets geöffnet.
  - Danach wird `repository.createStudyCardSet()` aufgerufen.

- Read:
  - Die Sets werden mit `repository.getStudyCardSets()` aus Firestore geladen.
  - Die geladenen Daten werden mit einem `FutureBuilder` dargestellt.

- Update: `_editSet()`
  - Durch Wischen nach links kann "Bearbeiten" ausgewählt werden.
  - Das bestehende Set wird im Formular geöffnet.
  - Anschliessend wird `repository.updateStudyCardSet()` aufgerufen.

- Delete: `_deleteSet()`
  - Durch Wischen nach links kann "Löschen" ausgewählt werden.
  - Vor dem Löschen muss noch bestätigt werden, dass man wirklich löschen will.
  - Anschliessend wird `repository.deleteStudyCardSet()` aufgerufen.
  - Dabei werden auch die zum Set gehörenden Lernkarten gelöscht.

Das Formular für das Erstellen und Bearbeiten eines Lernkartensets befindet sich in `lib/features/study_card/presentation/study_card_set_form_screen.dart`. Dort werden Titel, optionale Beschreibung und die Einstellung "Öffentlich" erfasst bzw. bearbeitet und validiert. 

Für Lernkartensets und Lernkarten gibt es jeweils nur ein gemeinsames Formular zum Erstellen und Bearbeiten.Beim Erstellen wird das Formular leer geöffnet. Beim Bearbeiten wird dasselbe Formular mit den bereits vorhandenen Daten vorausgefüllt. Dadurch muss die Eingabe- und Validierungslogik nicht doppelt implementiert werden. Der Code bleibt kürzer, übersichtlicher und leichter wartbar.

---

### CRUD für Lernkarten in der Benutzeroberfläche

Im Screen `lib/features/study_card/presentation/study_card_set_detail_screen.dart` werden die Lernkarten eines ausgewählten Lernkartensets angezeigt.

- Create: `_createCard()`
  - Über den Floating Action Button wird eine neue Lernkarte erstellt.
  - Anschliessend wird `repository.createCard()` aufgerufen.

- Read:
  - Die Lernkarten werden mit `repository.getCards()` aus der Firestore-Subcollection `studyCards` geladen.
  - Die geladenen Karten werden mit einem `FutureBuilder` angezeigt.

- Update: `_editCard()`
  - Eine Lernkarte kann durch Wischen nach links und "Bearbeiten" geändert werden.
  - Danach wird `repository.updateCard()` aufgerufen.

- Delete: `_deleteCard()`
  - Eine Lernkarte kann durch Wischen nach links und "Löschen" entfernt werden.
  - Vor dem Löschen muss noch bestätigt werden, dass man wirklich löschen will.
  - Danach wird `repository.deleteCard()` aufgerufen.

Das Formular für das Erstellen und Bearbeiten einer Lernkarte befindet sich in `lib/features/study_card/presentation/study_card_form_screen.dart`. Dort werden Frage und Antwort eingegeben und vor dem Speichern validiert.

---


## 3. Was wurde gegenüber Teil 1 weiterentwickelt?

In Teil 1 wurden die Lernkartensets und Lernkarten noch mit lokalen Mock-Daten dargestellt. In Teil 2 wurde die App mit Firebase und Cloud Firestore verbunden. Die Daten werden nun dauerhaft in Firestore gespeichert und aus Firestore geladen.

Zusätzlich wurden folgende Funktionen umgesetzt:

- Neue Lernkartensets erstellen
- Lernkartensets bearbeiten
- Lernkartensets löschen
- Neue Lernkarten erstellen
- Lernkarten bearbeiten
- Lernkarten löschen
- Formulare mit Eingabevalidierung
- Zeichenbegrenzungen für Eingaben
- Ladeanzeige beim Laden von Firebase-Daten
- Leerer Zustand, wenn keine Daten vorhanden sind
- Fehlermeldungen bei Problemen mit Firebase
- Bestätigung vor dem Löschen
- Direkte Aktualisierung der Anzeige nach Änderungen

Die bestehende Darstellung der Lernkarten als umdrehbare Karten wurde beibehalten und mit den Firestore-Daten verbunden.

---

## 4. Was wäre eine sinnvolle nächste Erweiterung für Teil 3?

Eine sinnvolle nächste Erweiterung wäre Firebase Authentication. User könnten sich registrieren und anmelden. Dadurch könnten Lernkartensets einem bestimmten User zugeordnet werden und die "Entdecken"-Funktion könnte umgesetzt werden, wo man öffentliche Lernkartensets von anderen Usern sehen und hinzufügen kann.

Für Teil 3 wäre es auch sinnvoll, den Quizmodus zu implementieren, damit die erstellen Lernkartensets abgefragt werden können.

---
