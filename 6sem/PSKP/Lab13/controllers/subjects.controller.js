const DB = require('../database/db');
const { DataTypes } = require('sequelize');

class SubjectsAPI {
    async select(req, res) {
        let response;
        const sequelize = new DB();

        try {
            await sequelize.client_connect();
            response = await sequelize.subject.findAll();
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Внутренняя ошибка сервера' };
            res.status(500).json(response);
            return;
        }

        await sequelize.close_connection();
        res.status(200).json(response);
    }

    async insert(req, res) {
        let response;
        const { SUBJECT, SUBJECT_NAME, PULPIT } = req.body;

        const sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.subject.create({ SUBJECT, SUBJECT_NAME, PULPIT });
            response = { message: 'Успешно вставлено' };
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Не удалось вставить запись' };
            res.status(500).json(response);
            return;
        }
        await sequelize.close_connection();
        res.status(200).json(response);
    }

    async update(req, res) {
        let response;
        const { SUBJECT, SUBJECT_NAME, PULPIT } = req.body;

        const sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.subject.update({ SUBJECT_NAME, PULPIT }, { where: { SUBJECT } });
            response = { message: 'Успешно обновлено' };
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Не удалось обновить запись' };
            res.status(500).json(response);
            return;
        }

        await sequelize.close_connection();
        res.status(200).json(response);
    }

    async delete(req, res) {
        let response;
        const { id } = req.params;

        const sequelize = new DB();

        try {
            await sequelize.client_connect();
            await sequelize.subject.destroy({ where: { SUBJECT: id } });
            response = { message: 'Успешно удалено' };
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Не удалось удалить запись' };
            res.status(500).json(response);
            return;
        }

        await sequelize.close_connection();
        res.status(200).json(response);
    }
}

module.exports = new SubjectsAPI();
