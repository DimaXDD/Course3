const DB = require('../database/db');
const url = require('url');

class facultiesAPI {
    async select(req, res) {
        let response;
        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            response = await sequelize.faculty.findAll();
        } catch (e) {
            console.log(e)
        }
        res.end(JSON.stringify(response));
    }

    async selectWithParam(req, res) {
        let response;
        const { id } = req.params;
        console.log(id);
        let sequelize = new DB();
    
        try {
            await sequelize.client_connect();
            const faculty = await sequelize.subject.findAll({ 
                include: [{ 
                    model: sequelize.pulpit, 
                    where: { FACULTY: id }
                }] 
            });
    
            if (!faculty || faculty.length === 0) {
                response = { error: 'Faculty not found' };
                res.status(404).json(response);
                return;
            }
    
            response = faculty;
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }
    
        await sequelize.close_connection();
        res.status(200).json(response);
    }
    
    async insert(req, res) {
        let response;
        const { FACULTY, FACULTY_NAME } = req.body;
        console.log('FACULTY, FACULTY_NAME', FACULTY, FACULTY_NAME);
        let dbController = new DB(); 
    
        try {
            await dbController.client_connect();
            await dbController.faculty.create({ FACULTY: FACULTY, FACULTY_NAME: FACULTY_NAME }); 
            response = { message: 'Insert successful' };
        } catch (e) {
            console.log(e);
            response = { error: 'Failed to insert faculty' };
        }
        res.end(JSON.stringify(response));
    }

    async update(req, res) {
        let response;
        const { FACULTY, FACULTY_NAME } = req.body;

        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.faculty.update({ faculty_name: FACULTY_NAME }, { where: { faculty: FACULTY } });
            response = { message: 'Update successful' };
        } catch (e) {
            console.log(e);
            response = { error: 'Failed to update faculty' };
        }

        await sequelize.close_connection();
        res.end(JSON.stringify(response));
    }

    async delete(req, res) {
        let response;
        const { id } = req.params; 
    
        let sequelize = new DB();
    
        try {
            await sequelize.client_connect();
            await sequelize.faculty.destroy({ where: {faculty: id } }); 
            response = { message: 'Delete successful' };
        } catch (e) {
            console.log(e);
            response = { error: 'Failed to delete faculty' };
        }
    
        await sequelize.close_connection();
        res.end(JSON.stringify(response));
    }
}

module.exports = new facultiesAPI();
