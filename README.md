# Lernkarten-App

Flutter-App für das Modul "Mobile Apps" an der Teko Olten, Studiengang Wirtschaftsinformatik HF. App für die Verwaltung von digitalen Karteikarten.

## Verwendete Pakete

Für die Lernkarten in den Lernkartensets verwende ich das Paket flip_card_plus, das ich hier gefunden habe: <https://www.reddit.com/r/FlutterDev/comments/1txhczv/i_built_a_3d_flip_card_widget_for_flutter_with/?solution=ddc737d0f024d1dfddc737d0f024d1df&js_challenge=1&token=7afd7253fec22262ff1c52b1703fe9ec5817a11bb5d47db0b760705261452a56&jsc_orig_r=>

Es stellt das Widget `FlipCardPlus` bereit, dem man über die Parameter `front`und `back`zwei Widgets übergibt (Vorder- und Rückseite). Beim Tippen auf die Karte wird animiert zwischen den beiden gewechselt.

Vor dem Starten deshalb die Abhängigkeiten installieren, damit es funktioniert.

## Funktionen (im Moment)

- Übersicht über mehrere Lernkarten-Sets
- Detailansicht eines Sets mit umdrehbaren Karten (Frage/Antwort)
- Navigation über eine Bottom Navigation Bar (Meine Sets, Info, Profil)
- Seitenmenü (Drawer) mit Zusatzseiten (Entdecken, Einstellungen)

## App starten

1. [Flutter](https://docs.flutter.dev/get-started/install) installieren (falls noch nicht vorhanden)
2. Projekt entpacken und im Terminal in den Projektordner wechseln
3. Abhängigkeiten installieren:

   ```
   flutter pub get
   ```

4. App starten (z. B. im Browser oder auf einem angeschlossenen Gerät/Emulator):

   ```
   flutter run
   ```
