const { Sequelize, DataTypes, Transaction} = require('sequelize')
const { Op } = require('sequelize');

class DB_controller {
    constructor(db = 'TDS', login = 'sa', password = '1111') {
        this.sequelize = new Sequelize(
            db, 
            login, 
            password, 
            {
                host: 'localhost',
                dialect: 'mssql',
                logging: false
            }
        );
        this.faculty = this.sequelize.define('Faculty', {
            FACULTY: {
                type: DataTypes.CHAR(10),
                allowNull: false,
                primaryKey: true
            },
            FACULTY_NAME: {
                type: DataTypes.STRING,
                allowNull: false
            }
        }, {
            tableName: 'FACULTY', // Название таблицы
            timestamps: false // Если нет столбцов created_at и updated_at
        });
        // Определение модели Pulpit
        this.pulpit = this.sequelize.define('Pulpit', {
            PULPIT: {
                type: DataTypes.CHAR(10),
                allowNull: false,
                primaryKey: true
            },
            PULPIT_NAME: {
                type: DataTypes.STRING,
                allowNull: true
            },
            FACULTY: {
                type: DataTypes.CHAR(10),
                allowNull: false
            }
        }, {
            tableName: 'PULPIT', 
            timestamps: false,
        });
        // Определение модели Teacher
        this.teacher = this.sequelize.define('Teacher', {
            TEACHER: {
                type: DataTypes.CHAR(10),
                allowNull: false,
                primaryKey: true
            },
            TEACHER_NAME: {
                type: DataTypes.STRING,
                allowNull: true
            },
            PULPIT: {
                type: DataTypes.CHAR(10),
                allowNull: false
            }
        }, {
            tableName: 'TEACHER',
            timestamps: false 
        });
        // Определение модели Subject
        this.subject = this.sequelize.define('Subject', {
            SUBJECT: {
                type: DataTypes.CHAR(10),
                allowNull: false,
                primaryKey: true
            },
            SUBJECT_NAME: {
                type: DataTypes.STRING,
                allowNull: false
            },
            PULPIT: {
                type: DataTypes.CHAR(10),
                allowNull: false
            }
        }, {
            tableName: 'SUBJECT', 
            timestamps: false 
        });
        // Определение модели AuditoriumType
        this.auditoriumType = this.sequelize.define('AuditoriumType', {
            AUDITORIUM_TYPE: {
                type: DataTypes.CHAR(10),
                allowNull: false,
                primaryKey: true
            },
            AUDITORIUM_TYPENAME: {
                type: DataTypes.STRING,
                allowNull: false,
                //unique: true
            }
        }, {
            tableName: 'AUDITORIUM_TYPE', 
            timestamps: false 
        });
        // Определение модели Auditorium
        this.auditorium = this.sequelize.define('Auditorium', {
            AUDITORIUM: {
                type: DataTypes.CHAR(10),
                allowNull: false,
                primaryKey: true
            },
            AUDITORIUM_NAME: {
                type: DataTypes.STRING,
                allowNull: true
            },
            AUDITORIUM_CAPACITY: {
                type: DataTypes.INTEGER,
                allowNull: true
            },
            AUDITORIUM_TYPE: {
                type: DataTypes.CHAR(10),
                allowNull: false
            }
        }, {
            tableName: 'AUDITORIUM',
            timestamps: false 
        });
        // Определение внешних ключей
        this.pulpit.belongsTo(this.faculty, { foreignKey: 'FACULTY', targetKey: 'FACULTY' });
        this.teacher.belongsTo(this.pulpit, { foreignKey: 'PULPIT', targetKey: 'PULPIT' });
        this.subject.belongsTo(this.pulpit, { foreignKey: 'PULPIT', targetKey: 'PULPIT' });
        this.auditorium.belongsTo(this.auditoriumType, { foreignKey: 'AUDITORIUM_TYPE', targetKey: 'AUDITORIUM_TYPE' });
        
        //задание 4
        this.auditorium.addScope('capacityRange', {
            where: {
              AUDITORIUM_CAPACITY: {
                [Sequelize.Op.between]: [10, 60]
              }
            }
          });

        //Задание 5
        this.faculty.addHook('beforeCreate', 'beforeCreateFaculty', (faculty, options) => {
            console.log('Before creating faculty:', faculty.FACULTY);
          });
          
        this.faculty.addHook('afterCreate', 'afterCreateFaculty', (faculty, options) => {
            console.log('After creating faculty:', faculty.FACULTY);
          });
    }

    async client_connect() {
        try {
            await this.sequelize.authenticate();
            console.log('Соединение с базой данных установлено успешно.');
            await this.sequelize.sync({ alter: true });
            console.log('Модели успешно синхронизированы');
        } catch (error) {
            console.error('Ошибка подключения к базе данных:', error);
        }
    }

    async call_query(qry) {
        try {
            const result = await this.sequelize.query(qry);
            return result;
        } catch (error) {
            console.error('Ошибка выполнения запроса:', error);
            return error;
        }
    }

    async close_connection() {
        await this.sequelize.close();
        console.log('Соединение с базой данных закрыто.');
    }

    
    async task6() {
        const transaction = await this.sequelize.transaction({
            timeout: 60000 // Установка тайм-аута
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
            // В случае ошибки отменяем транзакцию
            await transaction.rollback();
            console.error('Ошибка выполнения транзакции:', error);
        }
    }
}

module.exports = DB_controller;
