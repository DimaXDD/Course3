const express = require("express");
const session = require("express-session");
const path = require('path');
const jwt = require("jsonwebtoken");
const Users = require("./models/Users.js");
const redis = require("redis");
const cookieParser = require("cookie-parser");
const fs = require("fs");
const sequelize = require("./db/db.js");

const redisClient = redis.createClient();

const app = express();

app.use(
  session({
    secret: "12345",
    resave: false,
    saveUninitialized: false,
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.get("/login", (req, res) => {
  res.sendFile(path.join(__dirname, 'login.html'));
});

app.post("/login", async (req, res) => {
  redisClient.on("error", (err) => {
    console.error("Redis error:", err);
    res.status(500).send("Internal Server Error");
  });

  const { username, password } = req.body;

  try {
    const user = await Users.findOne({ where: { username: username } });

    if (user) {
      if (user.password === password) {
        req.session.user = user;

        const accessToken = jwt.sign({ username: user.username, id: user.id }, 'access_secret', { expiresIn: '10m' });
        const refreshToken = jwt.sign({ username: user.username, id: user.id }, 'refresh_secret', { expiresIn: '24h' });


        res.cookie("accessToken", accessToken, {
          httpOnly: true,
          sameSite: "strict",
        });

        res.cookie("refreshToken", refreshToken, {
          httpOnly: true,
          sameSite: "strict",
          path: "",
        });

        res.redirect("/resource");
      } else {
        res.status(401).send("Incorrect password");
      }
    } else {
      res.redirect("/login");
    }
  } catch (err) {
    console.error("Error:", err);
    res.status(500).send("Internal Server Error");
  }
});

function decodeToken(token) {
  try {
    const decoded = jwt.decode(token);
    return decoded;
  } catch (error) {
    console.error("Error decoding token:", error.message);
    return null;
  }
}

app.get("/refresh-token", async (req, res) => {
  const existRefreshToken = req.cookies.refreshToken;

  const decodedToken = decodeToken(existRefreshToken);
  if (decodedToken) {
    console.log("Decoded token:", decodedToken);
  } else {
    console.log("Token decoding failed.");
  }

  if (existRefreshToken) {
    jwt.verify(existRefreshToken, "refresh_secret", async (err, user) => {
      if (err) {
        return res.status(401).send("Unauthorized");
      } else if (user) {
        const userId = user.id;
        const result1 = await redisClient.get(`key${existRefreshToken}`);
        if (`value${userId}` === result1) {
          return res.status(401).send("Refresh token in black list");
        }

        const newUser = await Users.findOne({ where: { id: userId } });

        const newAccessToken = jwt.sign({ username: newUser.username, id: newUser.id  }, 'access_secret', { expiresIn: '10m' });
        const newRefreshToken = jwt.sign({ username: newUser.username, id: newUser.id }, 'refresh_secret', { expiresIn: '24h' });

        res.clearCookie("accessToken");
        res.clearCookie("refreshToken");

        res.cookie("accessToken", newAccessToken, {
          httpOnly: true,
          sameSite: "strict",
        });
        res.cookie("refreshToken", newRefreshToken, {
          httpOnly: true,
          sameSite: "strict",
        });

        await redisClient.set(`key${existRefreshToken}`, `value${userId}`);
        const keys = await redisClient.keys(`key${existRefreshToken}*`);

        const results = await Promise.all(
          keys.map(async (key) => {
            const value = await redisClient.get(key);
            return { key, value };
          })
        );

        const result = await redisClient.get(`key${existRefreshToken}`);

        console.log("Refresh token in black list", result);

        const filePath = "E:/3course/6sem/PSKP/Lab17/blacklist_tokens.txt";
        const data = "id - " + userId + ":" + existRefreshToken + "\n";

        fs.appendFile(filePath, data, (err) => {
          if (err) {
            console.error("Error writing to blacklist_tokens.txt:", err);
          } else {
            console.log("Token added to blacklist_tokens.txt:", data);
          }
        });

        res.redirect("/resource");
      }
    });
  } else {
    res.status(400).send("No refresh token provided");
  }
});

app.get("/logout", (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      console.error("Error destroying session:", err);
      res.status(500).send("Internal Server Error");
    } else {
      res.clearCookie("accessToken");
      res.clearCookie("refreshToken");
      res.redirect("/login");
    }
  });
});

app.get("/resource", async (req, res) => {
  if (req.session && req.session.user) {
    const userId = req.session.user.id;
    const refreshToken = req.cookies.refreshToken;

    try {
      const result2 = await redisClient.get(`key${refreshToken}`);
      if (`value${userId}` === result2) {
        return res.status(401).send("Refresh token is in the blacklist");
      }
    } catch (error) {
      console.error("Error accessing Redis:", error);
      return res.status(500).send("Internal Server Error");
    }

    res.send(
      `Resource page. You're authorized. <br/> Username: ${req.session.user.username}`
    );
  } else {
    res.status(401).send("Unauthorized");
  }
});

app.get("/register", (req, res) => {
  res.sendFile(path.join(__dirname, 'register.html'));
});

app.post("/register", async (req, res) => {
  const { username, password, info } = req.body;
  try {
    const newUser = await Users.create({ username, password, info });
    res.status(200).send("User registered successfully");
  } catch (err) {
    res.status(500).send("Error registering user");
  }
});

app.use(function (err, req, res, next) {
  res.send(err.message);
});

sequelize.sync().then(() => {
  app.listen(3000, () => {
    redisClient.connect();
    redisClient.on("error", (err) => {
      console.log("error " + err);
    });
    redisClient.on("connect", () => {
      console.log("redis ok");
    });
    sequelize.authenticate().then(() => console.log("sequelize ok"));
  });
});
