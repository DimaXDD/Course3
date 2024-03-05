const DB_controller = require('../dataBase/DB');
const url = require('url');

class facultiesAPI {
    async select(req, res) {
        let response;
        let DB = new DB_controller();

        try {
            response = await DB.prismaClient.fACULTY.findMany();
        } catch (e) {
            console.log(e)
        }
        res.end(JSON.stringify(response));
    }

    async selectWithParam(req, res) {
        let response;
        const { id } = req.params;
        let DB = new DB_controller();
    
        try {
            const faculty = await DB.prismaClient.fACULTY.findUnique({
                where: {
                    FACULTY: id
                },
                include: {
                    PULPIT_PULPIT_FACULTYToFACULTY: {
                        include: {
                            SUBJECT_SUBJECT_PULPITToPULPIT: true
                        }
                    }
                }
            });
    
            if (!faculty) { // Check if faculty exists
                response = { error: 'Faculty not found' };
                res.status(404).json(response);
                return;
            }
    
            response = faculty; // Response includes the faculty with associated pulpits and subjects
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
        const { FACULTY, FACULTY_NAME, PULPITS } = req.body; // Добавляем PULPITS для передачи кафедр
        
        try {
            // Создаем факультет
            response = await prisma.fACULTY.create({
                data: {
                    FACULTY: FACULTY,
                    FACULTY_NAME: FACULTY_NAME,
                    PULPIT_PULPIT_FACULTYToFACULTY: { // Добавляем связанные кафедры
                        create: PULPITS // Передаем данные кафедр для создания
                    }
                }
            });
            
            response = { message: 'Insert successful', faculty: response }; // Возвращаем созданный факультет и его кафедры
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to insert faculty' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
    async update(req, res) {
        let prisma = new DB_controller().prismaClient;

        let response;
        const { FACULTY, FACULTY_NAME } = req.body;
    
        try {
            response = await prisma.fACULTY.update({
                where: { FACULTY: FACULTY },
                data: { FACULTY_NAME: FACULTY_NAME }
            });
            response = { message: 'Update successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to update faculty' };
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
            response = await prisma.fACULTY.delete({
                where: { FACULTY: id }
            });
            response = { message: 'Delete successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to delete faculty' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
}

module.exports = new facultiesAPI();
