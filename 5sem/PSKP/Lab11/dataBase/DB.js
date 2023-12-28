const sql = require('mssql');

class DB_controller {
    constructor() {
        this.config = {
            user:'sa',
            password:'1111',
            server:'localhost',
            database:'TDS',
            options: {trustServerCertificate: true },
            pool: {
                min: 4,
                max: 10,
                idleTimeoutMillis: 30000
            }
        };
    }

    async client_connect() {
        try {
            this.pool = await sql.connect(this.config);
        } catch (e) {
            console.error('Ошибка подключения к базе данных', e.stack);
        }
    }

    async call_query(qry) {
        try {
            let result = await this.pool.request().query(qry);
            return result;
        } catch (e) {
            console.error('Ошибка выполнения процедуры', e.stack);
            return e.originalError;
        }
    }

    async close_connection() {
        sql.close();
    }
}

module.exports = DB_controller;