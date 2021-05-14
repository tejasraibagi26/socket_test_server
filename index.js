const express = require("express");
const app = express();
const server = require("http").createServer(app);
const io = require("socket.io")(server);
// const config = require("config");
const { pdb } = require("./db_init/dbConn");

app.use(express.json());

app.get("/t", (req, res, next) => {
  console.log("test");
  res.status(200).json({
    msg: "health check done.",
  });
});

app.post("/login", (req, res, next) => {
  const query = "select * from users where user = ${userid}";
  pdb
    .any(query, { userid: req.body.userid })
    .then((result) => {
      console.log(result);
    })
    .catch((err) => console.log(err));
});

io.on("connection", (client) => {
  console.log("Client connected " + client.id);
  client.on("connect", () => {
    console.log("Hello");
  });
  client.on("/test", (data) => {
    console.log(data);
  });
  client.on("load-data", () => {
    const query = "select * from todos";
    pdb
      .any(query)
      .then((result) => client.emit("data", result))
      .catch((err) => console.log(err));
  });
  client.on("add-todo", (data) => {
    console.log(data["user"]);
    const query = 'insert into todos(todo, "user") values (${todo}, ${user})';
    pdb
      .any(query, { todo: data["todo"], user: data["user"] })
      .then(() => {
        const q2 = "select * from todos";
        pdb
          .any(q2)
          .then((result) => {
            client.emit("new-todo", result);
          })
          .catch((err) => console.log(err));
      })
      .catch((err) => console.log(err));
  });
});

var serverPort = process.env.PORT || 5000;

server.listen(serverPort, (err) => {
  if (err) throw err;
  console.log("Server Listening at " + serverPort);
});
