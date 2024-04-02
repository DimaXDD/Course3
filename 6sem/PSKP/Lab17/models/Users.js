const sequelize = require('../db/db.js');
const {DataTypes} = require("sequelize");

const USERS = sequelize.define('USERS', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    username: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false
    },
    info: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    timestamps: false,
    freezeTableName: true
});

module.exports = USERS;