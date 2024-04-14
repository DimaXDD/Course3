const Sequelize = require('sequelize');
const db = require('./db');


const UsersCASL = db.define(
    'UsersCASL',
    {
        id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
        username: { type: Sequelize.STRING, allowNull: false },
        email: { type: Sequelize.STRING, allowNull: false },
        password: { type: Sequelize.STRING, allowNull: false },
        role: { type: Sequelize.STRING, allowNull: false },
    },
    { Users: 'UsersCASL', tableName: 'users' }
);


const Commits = db.define(
    'Commits',
    {
        id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
        message: { type: Sequelize.STRING, allowNull: false },
        repoId: { type: Sequelize.INTEGER, allowNull: false },
    },
    { Users: 'Commits', tableName: 'commits' }
);


const Repos = db.define(
    'Repos',
    {
        id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
        name: { type: Sequelize.STRING, allowNull: false },
        authorId: { type: Sequelize.INTEGER, allowNull: false },
    },
    {
        Users: 'Repos',
        tableName: 'repos',
    }
);


UsersCASL.hasMany(Repos, { foreignKey: 'authorId' });
Repos.belongsTo(UsersCASL, { foreignKey: 'authorId' });

Repos.hasMany(Commits, { foreignKey: 'repoId' });
Commits.belongsTo(Repos, { foreignKey: 'repoId' });

module.exports = {
    UsersCASL,
    Repos,
    Commits
};