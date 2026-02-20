const express = require("express");
const sqlite3 = require("sqlite3").verbose();

const app = express();
const PORT = 3000;

// Middleware für JSON
app.use(express.json());

// Datenbank (wird automatisch erstellt)
const db = new sqlite3.Database("./database.db", (err) => {
  if (err) {
    console.error("Datenbank-Fehler:", err.message);
  } else {
    console.log("SQLite-Datenbank verbunden");
  }
});

// Tabelle für Highscores
db.run(`
  CREATE TABLE IF NOT EXISTS highscores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    player_name TEXT NOT NULL,
    score INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )
`);

// Test-Route
app.get("/", (req, res) => {
  res.json({ message: "Save the Ball API läuft" });
});

// Score speichern
app.post("/score", (req, res) => {
  const { player_name, score } = req.body;

  if (!player_name || score === undefined) {
    return res.status(400).json({ error: "Ungültige Daten" });
  }

  db.run(
    "INSERT INTO highscores (player_name, score) VALUES (?, ?)",
    [player_name, score],
    () => {
      res.json({ status: "Score gespeichert" });
    }
  );
});

// Highscores abrufen
app.get("/highscores", (req, res) => {
  db.all(
    "SELECT player_name, score, created_at FROM highscores ORDER BY score DESC LIMIT 10",
    [],
    (err, rows) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      res.json(rows);
    }
  );
});

// Server starten
app.listen(PORT, () => {
  console.log(`Server läuft auf http://localhost:${PORT}`);
});
