const {Sequelize} = require('sequelize');

const sequelize = new Sequelize('Lab17', 'sa', '1111', {
    host: 'localhost',
    dialect: 'mssql',
    dialectOptions: {
        options: {
            encrypt: true,
            trustServerCertificate: true
        }
    },
});

module.exports = sequelize;