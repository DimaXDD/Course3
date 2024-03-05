const DB_controller = require('../dataBase/DB');
const url = require('url');

class auditoriumsTypesAPI {

    async select(req, res) {
        let response;
        let DB = new DB_controller();

        try {
            response = await DB.prismaClient.aUDITORIUM_TYPE.findMany();
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }

        res.status(200).json(response);
    }
    
    async selectWithParam(req, res) {
        let response;
        const { id } = req.params;
        
        let DB = new DB_controller();
    
        try {
            // Используем метод findMany для поиска всех аудиторий с определенным типом
            response = await DB.prismaClient.aUDITORIUM_TYPE.findUnique({
                include:{
                    AUDITORIUM_AUDITORIUM_AUDITORIUM_TYPEToAUDITORIUM_TYPE:true
                },
                where: {
                    AUDITORIUM_TYPE: id // Устанавливаем условие по типу аудитории
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
        const { AUDITORIUM_TYPE, AUDITORIUM_TYPENAME } = req.body;
    
        try {
            response = await prisma.aUDITORIUM_TYPE.create({
                data: {
                    AUDITORIUM_TYPE: AUDITORIUM_TYPE,
                    AUDITORIUM_TYPENAME: AUDITORIUM_TYPENAME
                }
            });
            response = { message: 'Insert successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to insert auditorium type' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
    async update(req, res) {
        let prisma = new DB_controller().prismaClient;

        let response;
        const { AUDITORIUM_TYPE, AUDITORIUM_TYPENAME } = req.body;
    
        try {
            response = await prisma.aUDITORIUM_TYPE.update({
                where: { AUDITORIUM_TYPE: AUDITORIUM_TYPE },
                data: { AUDITORIUM_TYPENAME: AUDITORIUM_TYPENAME }
            });
            response = { message: 'Update successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to update auditorium type' };
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
            response = await prisma.aUDITORIUM_TYPE.delete({
                where: { AUDITORIUM_TYPE: id }
            });
            response = { message: 'Delete successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to delete auditorium type' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
}

module.exports = new auditoriumsTypesAPI();
