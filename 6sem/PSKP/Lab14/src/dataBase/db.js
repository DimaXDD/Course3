const { PrismaClient } = require('@prisma/client') 

class DB_controller {
    constructor() {
        this.prismaClient = new PrismaClient();
    }

    async client_connect() {
        try {
            this.prismaClient.$connect();
        } catch (error) {
            console.error('Ошибка подключения к базе данных:', error);
        }
    }

    async call_query(qry) {

        try {
            return result;
        } catch (error) {
            return error;
        }
    }

    async close_connection() {
        console.log('Соединение с базой данных закрыто.');
    }

    
    async task6() {
        const transaction = await this.sequelize.transaction({
            timeout: 60000
        });

        try {
            const result = await this.auditorium.update(
                { AUDITORIUM_CAPACITY: 0 },
                { where: { AUDITORIUM_CAPACITY: { [Op.gt]: 0 } }, transaction }
            );
            await new Promise(resolve => setTimeout(resolve, 10000));

            await transaction.rollback();

            console.log('Транзакция успешно отменена');
        } catch (error) {
            await transaction.rollback();
            console.error('Ошибка выполнения транзакции:', error);
        }
    }
}

module.exports = DB_controller;