const DB = require('../dataBase/DB');
const url = require('url');

class sauditoriumsTypesAPI{

    async select(req, res){
        let response;
        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query('SELECT * FROM AUDITORIUM_TYPE');
            console.log('SELECT AUDITORIUM_TYPE');
            
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
    async selectWithParam(req, res){
        let response;
        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`SELECT * FROM AUDITORIUM WHERE AUDITORIUM_TYPE = N'${req.params.id}'`);
            console.log('SELECT AUDITORIUM_TYPE');
            
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
        const { AUDITORIUM_TYPE, AUDITORIUM_TYPENAME } = req.body;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`INSERT INTO AUDITORIUM_TYPE VALUES ('${AUDITORIUM_TYPE}', '${AUDITORIUM_TYPENAME}')`);
            console.log('INSERT AUDITORIUM_TYPE');
            
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
        let { AUDITORIUM_TYPE, AUDITORIUM_TYPENAME } = req.body;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`UPDATE AUDITORIUM_TYPE SET AUDITORIUM_TYPENAME = N'${AUDITORIUM_TYPENAME}' WHERE AUDITORIUM_TYPE = N'${AUDITORIUM_TYPE}'`);
            console.log('update AUDITORIUM_TYPE');
            
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
            let subquery = await sqlConnection.call_query(`DELETE FROM AUDITORIUM WHERE AUDITORIUM_TYPE = '${req.params.id}'`);
            let data = await sqlConnection.call_query(`DELETE FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE = '${req.params.id}'`);
            console.log('delete AUDITORIUM_TYPE');
            
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

module.exports = new sauditoriumsTypesAPI();
