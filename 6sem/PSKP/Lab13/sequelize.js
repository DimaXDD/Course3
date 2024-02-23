const Sequelize = require('sequelize');

const sequelize = new Sequelize('TDS', 'sa', '1111', {
    host: 'localhost',
    dialect: 'mssql',
    define: {
        timestamps: false,
        hooks: {
            beforeDestroy() { console.log('Default hook: Destroy called') }
        }
    },
    pool: {
        max: 10,
        min: 1,
        idle: 20000
    },
    dialectOptions: {
        options: {
            encrypt: true,
            trustServerCertificate: true
        }
    }
});

sequelize.authenticate()
.then(() => {
    console.log('Соединение установлено. Ура!');
})
.catch(err => {
    console.log('Ошибка :(', err);
    sequelize.close();
})