const DB_controller = require('../dataBase/DB');

class teachersAPI {
    async select(req, res) {
        let response;
        const DB = new DB_controller();

        try {
            response = await DB.prismaClient.tEACHER.findMany();
        } catch (e) {
            console.error('Ошибка выполнения запроса', e);
            response = { error: 'Внутренняя ошибка сервера'};
            res.status(500).json(response);
            return;
        }
        res.status(200).json(response);
    }

    async insert(req, res) {
        let prisma = new DB_controller().prismaClient;

        let response;
        const { TEACHER, TEACHER_NAME, PULPIT } = req.body;
    
        try {
            response = await prisma.tEACHER.create({
                data: {
                    TEACHER: TEACHER,
                    TEACHER_NAME: TEACHER_NAME,
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
        const { TEACHER, TEACHER_NAME, PULPIT } = req.body;
    
        try {
            response = await prisma.tEACHER.update({
                where: { TEACHER: TEACHER },
                data: { TEACHER_NAME: TEACHER_NAME, PULPIT: PULPIT }
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
            response = await prisma.tEACHER.delete({
                where: { TEACHER: id }
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

module.exports = new teachersAPI();
