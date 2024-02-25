const DB = require('../dataBase/DB');
const { DataTypes } = require('sequelize');

class PulpitsAPI {

    async select(req, res) {
        let response;
        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            response = await sequelize.pulpit.findAll();
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
        const { PULPIT, PULPIT_NAME, FACULTY } = req.body;

        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.pulpit.create({ PULPIT: PULPIT, PULPIT_NAME: PULPIT_NAME, FACULTY: FACULTY });
            response = { message: 'Insert successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to insert pulpit' };
            res.status(500).json(response);
            return;
        }
        await sequelize.close_connection();
        res.status(200).json(response);
    }

    async update(req, res) {
        let response;
        const { PULPIT, PULPIT_NAME, FACULTY } = req.body;

        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.pulpit.update({ PULPIT_NAME: PULPIT_NAME, FACULTY: FACULTY }, { where: { PULPIT: PULPIT } });
            response = { message: 'Update successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to update pulpit' };
            res.status(500).json(response);
            return;
        }

        await sequelize.close_connection();
        res.status(200).json(response);
    }

    async delete(req, res) {
        let response;
        const { id } = req.params;

        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.pulpit.destroy({ where: { PULPIT: id } });
            response = { message: 'Delete successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to delete pulpit' };
            res.status(500).json(response);
            return;
        }

        await sequelize.close_connection();
        res.status(200).json(response);
    }
}

module.exports = new PulpitsAPI();
