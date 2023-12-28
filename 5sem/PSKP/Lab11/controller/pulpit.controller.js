const DB = require('../dataBase/DB');
const url = require('url');

class auditoriumAPI{

    async select(req, res){
        let response;
        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`SELECT * FROM PULPIT`);
            console.log('SELECT PULPIT');
            
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
        const { PULPIT, PULPIT_NAME, FACULTY } = req.body;
    
        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => {
            console.error('Ошибка подключения к базе данных', e.stack);
            console.log("======================", e);
            res.end(JSON.stringify(e));
        });
    
        try {
            console.log('INSERT PULPIT');
            let data = await sqlConnection.call_query(`INSERT INTO PULPIT VALUES ('${PULPIT}', '${PULPIT_NAME}', '${FACULTY}')`);
            
            if(data != undefined)
                if('rows' in data){
                    response = data.rows;
                }
                else{
                    response = data;
                }
        } catch (e) {
            console.error('Ошибка выполнения процедуры', e.stack);
            res.end(JSON.stringify(response));
        }
        await sqlConnection.close_connection();
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.end(JSON.stringify(response));
    }

    async update(req, res){
        let response;
        const { PULPIT, PULPIT_NAME, FACULTY } = req.body;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`UPDATE PULPIT SET PULPIT_NAME = N'${PULPIT_NAME}', FACULTY = N'${FACULTY}' WHERE PULPIT = N'${PULPIT}'`);
            console.log('update PULPIT');
            
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
            let subquery1 = await sqlConnection.call_query(`DELETE FROM SUBJECT WHERE PULPIT = '${req.params.id}'`);
            let subquery2 = await sqlConnection.call_query(`DELETE FROM TEACHER WHERE PULPIT =  '${req.params.id}'`);
            let data = await sqlConnection.call_query(`DELETE FROM PULPIT WHERE PULPIT = '${req.params.id}'`);
            console.log('delete PULPIT');
            
            if(data != undefined)
                if('rows' in data){
                    response = data.rows;
                }
                else{
                    response = data;
                }
        } catch (e) {
            console.error('Ошибка выполнения процедуры', e);
            response = e;
            res.end(JSON.stringify(response));
        }

        await sqlConnection.close_connection();
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.end(JSON.stringify(response));
    }

}

module.exports = new auditoriumAPI();
