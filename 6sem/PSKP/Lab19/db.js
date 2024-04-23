const Sequelize = require('sequelize');

module.exports = new Sequelize('Lab19', 'sa', '1111', {
    dialect: 'mssql',
    port: 1433,
    define: {
        timestamps: false,
    },
    pool: {
        max: 5,
        min: 0,
        idle: 10000,
    },
});