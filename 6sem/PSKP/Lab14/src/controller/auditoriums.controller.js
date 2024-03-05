const DB_controller = require('../dataBase/DB');
const url = require('url');

class auditoriumsAPI {

    async select(req, res) {
        let response;
        let DB = new DB_controller();

        try {
            response = await DB.prismaClient.aUDITORIUM.findMany();
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Internal Server Error' };
            res.status(500).json(response);
            return;
        }

        res.status(200).json(response);
    }

    async selectWithComp1(req, res) {
        let response;
        let DB = new DB_controller();
    
        try {
            response = await DB.prismaClient.aUDITORIUM.findMany({
                where: {
                    AND: [
                        {
                            AUDITORIUM: {
                                endsWith: "-1"
                            }
                        },
                        {
                            AUDITORIUM_TYPE: "ЛБ-К"
                        }
                    ]
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

    async auditoriumsSameCount(req, res) {
        let response;
        let DB = new DB_controller();
    
        try {
            response = await DB.prismaClient.aUDITORIUM.groupBy({
                by: ['AUDITORIUM_TYPE', 'AUDITORIUM_CAPACITY'],
                _count: true // Подсчитывает количество аудиторий с одинаковым типом и вместимостью
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
        const { AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE } = req.body;
    
        try {
            response = await prisma.aUDITORIUM.create({
                data: {
                    AUDITORIUM: AUDITORIUM,
                    AUDITORIUM_NAME: AUDITORIUM_NAME,
                    AUDITORIUM_CAPACITY: Number(AUDITORIUM_CAPACITY),
                    AUDITORIUM_TYPE: AUDITORIUM_TYPE
                }
            });
            response = { message: 'Insert successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to insert auditorium' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    
    async update(req, res) {
        let prisma = new DB_controller().prismaClient;
        let response;
        const { AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE } = req.body;
    
        try {
            response = await prisma.aUDITORIUM.update({
                where: { AUDITORIUM: AUDITORIUM },
                data: {
                    AUDITORIUM_NAME: AUDITORIUM_NAME,
                    AUDITORIUM_CAPACITY: Number(AUDITORIUM_CAPACITY),
                    AUDITORIUM_TYPE: AUDITORIUM_TYPE
                }
            });
            response = { message: 'Update successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to update auditorium' };
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
            response = await prisma.aUDITORIUM.delete({
                where: { AUDITORIUM: id }
            });
            response = { message: 'Delete successful' };
        } catch (e) {
            console.error('Error executing query', e);
            response = { error: 'Failed to delete auditorium' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }

    async transaction(req, res) {
        let response;
        const db = new DB_controller();
    
        try {
            await db.prismaClient.$transaction(async (tx) => {
                // Изменяем вместимость всех аудиторий на 100 (используя инкремент)
                await db.prismaClient.aUDITORIUM.updateMany({
                    data: {
                        AUDITORIUM_CAPACITY: {
                            increment: 100
                        }
                    }
                });
                throw new Error('Rollback changes');
            });
        } catch (e) {
            console.error('Error executing transaction', e);
            response = { error: 'Transaction failed' };
            res.status(500).json(response);
            return;
        }
    
        res.status(200).json(response);
    }
    /*
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


    */
}

module.exports = new auditoriumsAPI();