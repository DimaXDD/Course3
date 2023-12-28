const DB = require('../dataBase/DB');
const url = require('url');

class subjectsAPI{

    async select(req, res){
        let response;
        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`SELECT * FROM SUBJECT`);
            console.log('SELECT SUBJECT');
            
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
        const { SUBJECT, SUBJECT_NAME, PULPIT } = req.body;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`INSERT INTO SUBJECT VALUES ('${SUBJECT}', '${SUBJECT_NAME}', '${PULPIT}')`);
            
            console.log('INSERT SUBJECT');
            
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
        const { SUBJECT, SUBJECT_NAME, PULPIT } = req.body;

        let sqlConnection = new DB();
        await sqlConnection.client_connect().catch(e => console.error('Ошибка подключения к базе данных', e.stack));

        try {
            let data = await sqlConnection.call_query(`UPDATE SUBJECT SET SUBJECT_NAME = N'${SUBJECT_NAME}', PULPIT = N'${PULPIT}' WHERE SUBJECT = N'${SUBJECT}'`);
            console.log('update SUBJECT');
            
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
            let data = await sqlConnection.call_query(`DELETE FROM SUBJECT WHERE SUBJECT = N'${req.params.id}'`);
            console.log('delete SUBJECT');
            
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

module.exports = new subjectsAPI();