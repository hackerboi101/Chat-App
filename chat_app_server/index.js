const express = require("express");
var http = require("http");
const socketio = require("socket.io");
const cors = require("cors");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
const io = socketio(server, {
    cors: {
        origin: "*"
    },
});

//middleware
app.use(cors());
app.use(express.json());

io.on("connection", (socket) => {
    console.log("Connected");
})

server.listen(port, () => { 
    console.log(`Server started on port ${port}`);
});