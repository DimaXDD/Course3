const DB = require('../database/db');
const url = require('url');

class auditoriumsAPI {

    async select(req, res) {
        let response;
        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            response = await sequelize.auditorium.findAll();
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
        const { AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE } = req.body;

        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.auditorium.create({ AUDITORIUM: AUDITORIUM, AUDITORIUM_NAME: AUDITORIUM_NAME, AUDITORIUM_CAPACITY: AUDITORIUM_CAPACITY, AUDITORIUM_TYPE: AUDITORIUM_TYPE });
            response = { message: 'Insert successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to insert auditorium' };
            res.status(500).json(response);
            return;
        }
        await sequelize.close_connection();
        res.status(200).json(response);
    }

    async update(req, res) {
        let response;
        const { AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE } = req.body;

        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.auditorium.update({ AUDITORIUM_NAME: AUDITORIUM_NAME, AUDITORIUM_CAPACITY: AUDITORIUM_CAPACITY, AUDITORIUM_TYPE: AUDITORIUM_TYPE }, { where: { AUDITORIUM: AUDITORIUM } });
            response = { message: 'Update successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to update auditorium' };
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
            await sequelize.auditorium.destroy({ where: { AUDITORIUM: id } });
            response = { message: 'Delete successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to delete auditorium' };
            res.status(500).json(response);
            return;
        }

        await sequelize.close_connection();
        res.status(200).json(response);
    }

    async selectScope(req,res){
        let response;
        let sequelize = new DB();

        try {
            await sequelize.client_connect();
            response = await sequelize.auditorium.scope('capacityRange').findAll();
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }
        await sequelize.close_connection();
        res.status(200).json(response);
    }

    async transaction(req, res) {
        let response;
        let sequelize = new DB('TDS', 'sa', '1111');

        try {
            await sequelize.client_connect();
            await sequelize.task6();
            response = await sequelize.auditorium.findAll();
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }

        await sequelize.close_connection();
        res.status(200).json(response);
    }
}

module.exports = new auditoriumsAPI();