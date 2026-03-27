---
title: Save the Ball – Highscore System with Backend
---
In this learning period, we extend the game SaveTheBall by adding a backend and a database.

# Goal
The goal is:
- Save the player score
- Store data in a database
- Load and display the Top 10 highscores


# Previous Knowledge

We'll assume you already know:

- Basic programming concepts
- Basic JavaScript
- How to use Node.js and npm
- Basic understanding of APIs (GET and POST)

# What you'll learn

By the end, you’ll understand:

- How to create a backend using Node.js and Express
- How to use a SQLite database
- How to create API endpoints (GET and POST)
- How to send data from a game to a backend
- How to read JSON data using dkjson

# Tutorial

### 1. Install dependencies

Create a backend folder and install packages:

```bash
npm init -y
npm install express sqlite3

```

### Create a file index.js:

```js
const express = require("express");
const sqlite3 = require("sqlite3").verbose();

const app = express();
const PORT = 3000;

app.use(express.json());
```



### Database

We use SQLite to store highscores.

```js
const db = new sqlite3.Database("./database.db");

db.run(`
  CREATE TABLE IF NOT EXISTS highscores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    player_name TEXT,
    score INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )
`);
```


### API Endpoints
Save Score

```js
app.post("/score", (req, res) => {
  const { player_name, score } = req.body;

  db.run(
    "INSERT INTO highscores (player_name, score) VALUES (?, ?)",
    [player_name, score],
    () => {
      res.json({ message: "Score saved" });
    }
  );
});
```


### Get Highscores

```js
app.get("/highscores", (req, res) => {
  db.all(
    "SELECT player_name, score FROM highscores ORDER BY score DESC LIMIT 10",
    [],
    (err, rows) => {
      res.json(rows);
    }
  );
});
```


### Sending Data from the Game

When the player dies, the score is sent to the backend using curl:
```lua
local command = 'curl -X POST http://localhost:3000/score -H "Content-Type: application/json" -d "{\\"player_name\\":\\"RandomName\\",\\"score\\":100}"'
os.execute(command)
```


### Loading Highscores
We load the highscores into a JSON file:

```lua
local command = 'curl http://localhost:3000/highscores > highscores.json'
os.execute(command)
```

### Using dkjson

We use dkjson to decode JSON data:

```lua
local json = require("dkjson")

local file = io.open("highscores.json", "r")
local content = file:read("*all")
file:close()

local data = json.decode(content)
```
#### What is dkjson?

dkjson is a Lua library used to read JSON data.

The backend sends highscores in JSON format, but Lua cannot read JSON by default.  
dkjson converts the JSON data into a Lua table so the game can use it (for example to display highscores).

### Displaying Highscores

We display the highscores on the game over screen:

```lua
for i, score in ipairs(data) do
    love.graphics.printf(
        i .. ". " .. score.player_name .. " - " .. score.score,
        0,
        240 + (i * 22),
        screenWidth,
        "center"
    )
end
```

# Result



https://github.com/user-attachments/assets/76ec5d43-4979-4d90-9a19-b447612b0f0a


### Important

Before starting the game, the backend server must be running.

To do this, open the terminal, navigate to the backend folder, and start the server:

```bash
cd Backend
node index.js
```



# What could go wrong?
- The backend server is not running
- Wrong API URL (localhost:3000)
- curl command does not work
- JSON decoding fails (dkjson missing)
- Database file is not created

