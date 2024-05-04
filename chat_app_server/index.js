const express = require("express");
const dotenv = require("dotenv");
dotenv.config();
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
var http = require("http");
const socketio = require("socket.io")(server)
const cors = require("cors");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
const uri = process.env.MONGO_URI;

// Connect to MongoDB
mongoose.connect(uri)
    .then(() => console.log("Connected to MongoDB"))
    .catch(err => console.error("Could not connect to MongoDB", err));


socketio.on("connection", function(client) {
    console.log("Connected...", client.id);

    client.on('message', function name(data) {
        console.log(data);
        socketio.emit('message', data);
    });
    
    client.on('disconnect', function() {
        console.log("Disconnected...", client.id);
    });

    client.on('error', function(err) {
        console.log('Error detected', client.id);
        console.log(err);
    });
});


const multer = require("multer");
const { GridFsStorage } = require('multer-gridfs-storage');

const storage = new GridFsStorage({
  url: 'mongodb+srv://asifiq024:t6cmXlifxwZWq7eQ@chatapp.nhheol0.mongodb.net/?retryWrites=true&w=majority&appName=chatapp',
  options: { useNewUrlParser: true, useUnifiedTopology: true },
  file: (req, file) => {
    return new Promise((resolve, reject) => {
      const filename = file.originalname;
      if (!filename) {
        const err = new Error('File info could not be generated');
        err.code = 'FILE_INFO_GEN_ERR';
        reject(err);
      }
      const fileInfo = {
        filename: filename,
        bucketName: 'uploads',
        path: '/uploads/' + filename
      };
      resolve(fileInfo);
    });
  }
});

const upload = multer({ storage });


// User model
const User = mongoose.model("User", {
    username: String,
    name: String,
    email: String,
    password: String,
    profilepicture: String,
});

//middleware
app.use(cors());
app.use(express.json());


server.listen(port, function(err) {
    if(err) console.log(err);
    console.log('Listening on port', port);
});


//root get method

app.get("/", (req, res) => {
    res.send("Hello World!");
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

let blacklist = [];

app.get("/user/logout", (req, res) => {
    const token = req.headers.authorization.split(" ")[1];

    if (token) {
        blacklist.push(token);
    }

    res.status(200).json({
        success: true,
        message: "Logged out successfully"
    });
});


app.get("/user/profile", async (req, res) => {
    const token = req.headers.authorization.split(" ")[1];
    if (!token) {
        return res.status(401).json({
            success: false,
            message: "Unauthorized"
        });
    }
    if (blacklist.includes(token)) {
        return res.status(401).json({
            success: false,
            message: "Unauthorized"
        });
    }
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
        if (decoded) {
            const user = await User.findOne({ username: decoded.user.username });
            if (user) {
                res.status(200).json({
                    success: true,
                    data: {
                        username: user.username,
                        name: user.name,
                        email: user.email
                    }
                });
            } else {
                res.status(404).json({
                    success: false,
                    message: "User not found"
                });
            }
        } else {
            res.status(401).json({
                success: false,
                message: "Unauthorized"
            });
        }
    } catch (error) {
        console.log(error);
        res.status(500).send("Error getting profile data");
    }
});


app.put("/user/profile", async (req, res) => {
    const token = req.headers.authorization.split(" ")[1];
    if (!token) {
        return res.status(401).json({
            success: false,
            message: "Unauthorized"
        });
    }
    if (blacklist.includes(token)) {
        return res.status(401).json({
            success: false,
            message: "Unauthorized"
        });
    }
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
        if (decoded) {
            const user = await User.findOne({ username: decoded.user.username });
            if (user) {
                const { name, email } = req.body;
                user.name = name || user.name;
                user.email = email || user.email;
                await user.save();
                res.status(200).json({
                    success: true,
                    data: {
                        username: user.username,
                        name: user.name,
                        email: user.email
                    }
                });
            } else {
                res.status(404).json({
                    success: false,
                    message: "User not found"
                });
            }
        } else {
            res.status(401).json({
                success: false,
                message: "Unauthorized"
            });
        }
    } catch (error) {
        console.log(error);
        res.status(500).send("Error editing profile data");
    }
});


app.post("/user/profile/picture", upload.single("profilepicture") , async (req, res) => {
    const token = req.headers.authorization.split(" ")[1];
    if (!token) {
        return res.status(401).json({
            success: false,
            message: "Unauthorized"
        });
    }
    if (blacklist.includes(token)) {
        return res.status(401).json({
            success: false,
            message: "Unauthorized"
        });
    }

    console.log(req.file);
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
        if (decoded) {
            const user = await User.findOne({ username: decoded.user.username });
            if (user) {

                if (!req.file) {
                    return res.status(400).json({
                        success: false,
                        message: "No file uploaded"
                    });
                }

                console.log(req.file.filename);

                user.profilepicture = req.file.filename;

                console.log(user.profilepicture);
                await user.save();

                console.log(user.profilepicture);
                res.status(200).json({
                    success: true,
                    data: {
                        profilepicture: user.profilepicture
                    }
                });

            } else {
                res.status(404).json({
                    success: false,
                    message: "User not found"
                });
            }
        } else {
            res.status(401).json({
                success: false,
                message: "Unauthorized"
            });
        }
    } catch (error) {
        console.log(error);
        res.status(500).send("Error editing profile data");
    }
});