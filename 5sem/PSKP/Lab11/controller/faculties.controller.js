const DB = require('../dataBase/DB');
const url = require('url');

class facultiesAPI{

    async select(req, res){
        let response;
        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`SELECT * FROM FACULTY`);
            console.log('SELECT FACULTY');
            
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
            let data = await sqlConnection.call_query(`SELECT * FROM PULPIT WHERE FACULTY = N'${req.params.id}'`);
            console.log('SELECT FACULTY');
            
            if(data != undefined)
                if('rows' in data){
                    response = data.rows;
                }
                else{
                    response = data;
                }
        } catch (e) {
            console.error('Ошибка выполнения процедуры', e.stack);
            response = e.stack;
        }
        await sqlConnection.close_connection();
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.end(JSON.stringify(response));
    }
    async update(req, res){
        let response;
        const { FACULTY, FACULTY_NAME } = req.body;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`UPDATE FACULTY SET FACULTY_NAME = N'${FACULTY_NAME}' WHERE FACULTY = N'${FACULTY}'`);
            console.log('update FACULTY');
            
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
            let subquery1 = await sqlConnection.call_query(`DELETE FROM SUBJECT WHERE PULPIT IN (SELECT PULPIT FROM PULPIT WHERE FACULTY = N'${req.params.id}')`);
            let subquery2 = await sqlConnection.call_query(`DELETE FROM TEACHER WHERE PULPIT IN (SELECT PULPIT FROM PULPIT WHERE FACULTY = N'${req.params.id}')`);
            let subquery3 = await sqlConnection.call_query(`DELETE FROM PULPIT WHERE FACULTY = N'${req.params.id}'`);
            let data = await sqlConnection.call_query(`DELETE FROM FACULTY WHERE FACULTY = N'${req.params.id}'`);
            console.log('delete FACULTY');
            
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

module.exports = new facultiesAPI();