const DB_controller = require('../dataBase/DB');

class SubjectsAPI {
    async select(req, res) {
        let response;
        const DB = new DB_controller();

        try {
            response = await DB.prismaClient.sUBJECT.findMany();
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Внутренняя ошибка сервера' };
            res.status(500).json(response);
            return;
        }

        res.status(200).json(response);
    }

    async insert(req, res) {
        let prisma = new DB_controller().prismaClient;

        let response;
        const { SUBJECT, SUBJECT_NAME, PULPIT } = req.body;
    
        try {
            response = await prisma.sUBJECT.create({
                data: {
                    SUBJECT: SUBJECT,
                    SUBJECT_NAME: SUBJECT_NAME,
                    PULPIT: PULPIT
                }
            });
            response = { message: 'Успешно вставлено' };
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Не удалось вставить запись' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
    async update(req, res) {
        let prisma = new DB_controller().prismaClient;

        let response;
        const { SUBJECT, SUBJECT_NAME, PULPIT } = req.body;
    
        try {
            response = await prisma.sUBJECT.update({
                where: { SUBJECT: SUBJECT },
                data: { SUBJECT_NAME: SUBJECT_NAME, PULPIT: PULPIT }
            });
            response = { message: 'Успешно обновлено' };
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Не удалось обновить запись' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
    async delete(req, res) {
        let prisma = new DB_controller().prismaClient;

        let response;
        const { id } = req.params;
    
        try {
            response = await prisma.sUBJECT.delete({
                where: { SUBJECT: id }
            });
            response = { message: 'Успешно удалено' };
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Не удалось удалить запись' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
}

module.exports = new SubjectsAPI();
