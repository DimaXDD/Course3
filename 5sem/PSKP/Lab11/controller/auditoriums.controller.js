const DB = require('../dataBase/DB');
const url = require('url');

class auditoriumsAPI{

    async select(req, res){
        let response;
        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query('SELECT * FROM AUDITORIUM');
            console.log('SELECT AUDITORIUM');
            
            if(data != undefined)
                if('rows' in data){
                    response = data.rows;
                }
                else{
                    response = data;
                }
        } catch (e) {
            console.error('Ошибка выполнения процедуры', e.stack);
            response = e;
        }
        await sqlConnection.close_connection();
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.end(JSON.stringify(response));
    }

    async insert(req, res){
        let response;
        const { AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE } = req.body;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`INSERT INTO AUDITORIUM VALUES (N'${AUDITORIUM}', N'${AUDITORIUM_NAME}', ${AUDITORIUM_CAPACITY}, N'${AUDITORIUM_TYPE}')`);
            console.log('INSERT AUDITORIUM');
            
            if(data != undefined)
                if('rows' in data){
                    response = data.rows;
                }
                else{
                    response = data;
                }
        } catch (e) {
            console.error('Ошибка выполнения процедуры', e.stack);
            response = e;
        }
        await sqlConnection.close_connection();
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.end(JSON.stringify(response));
    }

    async update(req, res){
        let response;
        const { AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE } = req.body;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`UPDATE AUDITORIUM SET AUDITORIUM_NAME = N'${AUDITORIUM_NAME}', AUDITORIUM_CAPACITY = ${AUDITORIUM_CAPACITY}, AUDITORIUM_TYPE = N'${AUDITORIUM_TYPE}' WHERE AUDITORIUM = N'${AUDITORIUM}'`);
            console.log('update AUDITORIUM');
            
            if(data != undefined)
                if('rows' in data){
                    response = data.rows;
                }
                else{
                    response = data;
                }
        } catch (e) {
            console.error('Ошибка выполнения процедуры', e.stack);
            response = e;
        }
        await sqlConnection.close_connection();
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.end(JSON.stringify(response));
    }

    async delete(req, res){
        let response;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`DELETE FROM AUDITORIUM WHERE AUDITORIUM = N'${req.params.id}'`);
            console.log('delete AUDITORIUM');
            
            if(data != undefined)
                if('rows' in data){
                    response = data.rows;
                }
                else{
                    response = data;
                }
        } catch (e) {
            console.error('Ошибка выполнения процедуры', e.stack);
            response = e;
        }

        await sqlConnection.close_connection();
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.end(JSON.stringify(response));
    }

}

module.exports = new auditoriumsAPI();