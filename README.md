# Lern-Periode 9


Projekt: Save the Ball – Leaderboard Backend

# Grob-Planung

1.)Welche Backend-Technologie / API möchte ich für mein bestehendes Spiel erstellen?

Für mein Spiel Save the Ball möchte ich ein einfaches Backend mit einer REST-API erstellen, das über HTTP mit dem Spiel kommuniziert.

2.)Welche Funktionalitäten soll das Backend (Leaderboard / Savegame) bereitstellen?

Das Backend soll Highscores speichern und die besten Ergebnisse als Leaderboard wieder zur Verfügung stellen.

3.)Was möchte ich in dieser Lernperiode insbesondere lernen oder üben (Backend, SQL, API-Design)?

Ich möchte den Aufbau eines Backends, den Umgang mit einer API sowie die Anbindung einer SQL-Datenbank lernen und üben.

# Projekt-Idee

Ich erweitere mein bestehendes Spiel Save the Ball (Lua / LÖVE2D) um ein Backend mit API, das ein SQL-basiertes Leaderboard bereitstellt.
Das Spiel soll Scores an das Backend senden können, welche persistent in einer Datenbank gespeichert und später wieder abgerufen werden. 

## 20.02
✍️ Heute habe ich… (50–100 Wörter)

Heute habe ich mich mit dem Backend für mein Projekt beschäftigt. Zuerst habe ich mich definitiv für Node.js mit Express entschieden und die Entwicklungsumgebung eingerichtet. Danach habe ich ein Backend-Projekt erstellt, die benötigten Pakete installiert und einen ersten Server zum Laufen gebracht. Zusätzlich habe ich eine SQLite-Datenbank angebunden. Das Backend konnte ich im Browser testen, wodurch ich gesehen habe, dass alles korrekt funktioniert. Damit habe ich eine gute Grundlage für die weitere Arbeit geschaffen.

☝️ Vergessin sie nicht, ihren Code auf Github hochzuladen




## 27.02

- [X] Sqlite installieren.
- [X] Den POST-Endpunkt verwenden, um Scores zu speichern, und prüfen, ob diese korrekt in der Datenbank abgelegt werden.
- [ ] Den GET-Endpunkt testen und kontrollieren, ob die Highscores korrekt sortiert und begrenzt zurückgegeben werden.
- [X] Den bestehenden Code leicht kommentieren.

✍️ Heute habe ich… (50–100 Wörter)



☝️ Vergessin sie nicht, ihren Code auf Github hochzuladen



## 06.03
- [X] Den GET-Endpunkt testen und kontrollieren, ob die Highscores korrekt sortiert werden.
- [ ] Der Nutzer muss am Anfang sein Namen eingeben müssen, damit es nachher in der Datenbank gespeichert werden kann.
- [X] Den Settings-Button aus dem Spiel entfernen.
- [X] Ein Bild des Spiel Logos auf der Hauptseite einbauen, da das Menü aktuell sehr leer wirkt. 


✍️ Heute habe ich… (50–100 Wörter)

Heute habe ich SQLite installiert. Ich wollte unbedingt wissen, ob die Verbindung mit der Datenbank klappt. Ich habe den Test im Terminal gemacht und als Ergebnis wurde es im Browser angezeigt. Ich habe noch den „SQLite Viewer“ installiert, damit ich die Datenbank direkt über VS Code sehen kann.

☝️ Vergessin sie nicht, ihren Code auf Github hochzuladen


## 20.03

- [ ] Der Nutzer muss am Anfang sein Namen eingeben müssen, damit es nachher in der Datenbank gespeichert werden kann.
- [ ] Die Buttons sollten auf der Vorderseite in der Mitte seite und nicht links.
- [ ] Das Logo soll die Vorderseite ausfüllen, sodass nur noch die Buttons darüber sichtbar sind.
- [ ] Die Punktzahl nach Spielende automatisch in der Datenbank speichern.


✍️ Heute habe ich… (50–100 Wörter)

Heute habe ich den GET-Endpunkt getestet und es war erfolgreich. Es hat funktioniert. Der Test war erfolgreich. Ich habe den Settings-Button entfernt, da er keine Funktion hatte. Auf der Vorderseite habe ich ein Logo hinzugefügt.

☝️ Vergessin sie nicht, ihren Code auf Github hochzuladen




