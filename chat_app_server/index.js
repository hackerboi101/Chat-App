const express = require("express");
const dotenv = require("dotenv");
dotenv.config();
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
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

// Connect to MongoDB
mongoose.connect("mongodb://localhost:27017/chat_app")
    .then(() => console.log("Connected to MongoDB"))
    .catch(err => console.error("Could not connect to MongoDB", err));

// Define User model
const User = mongoose.model("User", {
    username: String,
    name: String,
    email: String,
    password: String
});

//middleware
app.use(cors());
app.use(express.json());

io.on("connection", (socket) => {
    console.log("Connected");
    console.log(socket.id, "has joined");
    socket.on("/test", (msg) => {
        console.log(msg);
    });
})

server.listen(port, "192.168.0.171", () => { 
    console.log(`Server started on port ${port}`);
});

app.post("/user/signup", async (req, res) => {
    console.log(req.body);

    const { username, name, email, password } = req.body;

    if (!password) {
        return res.status(400).send("Password is required");
    }

    const hashedPassword = bcrypt.hashSync(password, 10);

    const newUser = new User({
        username,
        name,
        email,
        password: hashedPassword
    });

    try {
        await newUser.save();

        let token = jwt.sign({ user: newUser }, process.env.JWT_SECRET_KEY);

        res.status(201).json({ 
            success: true,
            data: {
                userName: newUser.username,
                name: newUser.name,
                email: newUser.email,
                token: token
            },
        });

        console.log("User registered successfully");
    } catch (error) {
        console.log(error);
        res.status(500).send("Error registering user");
    }
});

app.post("/user/login", async (req, res) => {
    console.log(req.body);

    let { username, password } = req.body;

    try {
        let existingUser = await User.findOne({ username: username });

        if (existingUser) {
            if (bcrypt.compareSync(password, existingUser.password)) {
                let token = jwt.sign({ user: existingUser }, process.env.JWT_SECRET_KEY);
                res.status(200).json({
                    success: true,
                    data: {
                        userName: existingUser.username,
                        email: existingUser.email,
                        token: token
                    }
                });
            } else {
                res.status(400).json({
                    success: false,
                    message: "Invalid password"
                });
            }
        } else {
            res.status(400).json({
                success: false,
                message: "User not found"
            });
        }
    } catch (error) {
        console.log(error);
        res.status(500).send("Error logging in");
    }
});