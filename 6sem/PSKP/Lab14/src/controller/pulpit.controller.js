const DB_controller = require('../dataBase/DB');

class PulpitsAPI {

    async select(req, res) {
        let response;
        let DB = new DB_controller();

        try {
            response = await DB.prismaClient.pULPIT.findMany();
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }

        res.status(200).json(response);
    }

    async selectPulpit(req, res) {
        const page = req.query.page ? parseInt(req.query.page) : 1; // Получаем номер страницы из запроса, если не указан, то по умолчанию первая страница
        const perPage = 10; // Количество кафедр на странице
    
        let response;
        let DB = new DB_controller();
    
        try {
            response = await DB.prismaClient.pULPIT.findMany({
                include: {
                    _count: {
                        select: { TEACHER_TEACHER_PULPITToPULPIT: true }
                    }
                },
                skip: (page - 1) * perPage, // Пропускаем предыдущие кафедры на предыдущих страницах
                take: perPage // Получаем только указанное количество кафедр на странице
            });
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }

    async puplitsWithoutTeachers(req, res) {
        let response;
        let DB = new DB_controller();

        try {
            response = await DB.prismaClient.pULPIT.findMany({
                where:{
                    TEACHER_TEACHER_PULPITToPULPIT : {
                        none: {}
                    }
                }
            });
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }

        res.status(200).json(response);
    }

    async pulpitsWithVladimir(req, res) {
        let response;
        let DB = new DB_controller();
    
        try {
            response = await DB.prismaClient.pULPIT.findMany({
                where: {
                    TEACHER_TEACHER_PULPITToPULPIT: {
                        some: {
                            TEACHER_NAME: {
                                contains : "Владимир"
                            }
                        }
                    }
                }
            });
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }

    async insert(req, res) {
        let prisma = new DB_controller().prismaClient;
    
        let response;
        const { PULPIT, PULPIT_NAME, FACULTY_PULPIT } = req.body;
    
        try {
            // Проверяем существует ли факультет
            let faculty = await prisma.fACULTY.findUnique({
                where: {
                    FACULTY: FACULTY_PULPIT.FACULTY
                }
            });
    
            if (!faculty) {
                // Создаем новый факультет, если он не существует
                faculty = await prisma.fACULTY.create({
                    data: {
                        FACULTY: FACULTY_PULPIT.FACULTY,
                        FACULTY_NAME: FACULTY_PULPIT.FACULTY_NAME
                    }
                });
            }
    
            // Создаем кафедру только если факультет не существует или не указаны кафедры
            if (!faculty || !FACULTY_PULPIT) {
                response = await prisma.pULPIT.create({
                    data: {
                        PULPIT: PULPIT,
                        PULPIT_NAME: PULPIT_NAME,
                        FACULTY: FACULTY
                    }
                });
            }
    
            response = { message: 'Insert successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to insert pulpit' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }

    async update(req, res) {
        let prisma = new DB_controller().prismaClient;

        let response;
        const { PULPIT, PULPIT_NAME, FACULTY } = req.body;
    
        try {
            response = await prisma.pULPIT.update({
                where: { PULPIT: PULPIT },
                data: { PULPIT_NAME: PULPIT_NAME, FACULTY: FACULTY }
            });
            response = { message: 'Update successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to update pulpit' };
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
            response = await prisma.pULPIT.delete({
                where: { PULPIT: id }
            });
            response = { message: 'Delete successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to delete pulpit' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
}

module.exports = new PulpitsAPI();
