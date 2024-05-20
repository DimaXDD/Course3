const {UsersCASL} = require('../models.js');

class UserController{
    async getAllUsers (req, res){
        try{
            req.ability.throwUnlessCan('read', 'UsersCASL', 'all');
            const users = await UsersCASL.findAll({
                attributes: ['id', 'username', 'email', 'role'],
            });
            res.status(200).end(JSON.stringify(users, null, 4));
        }
        catch(err){
            console.log(err);
            res.status(403).send('У вас нет разрешения на просмотр всех пользователей или ваш токен истек');
        }
    }

    async getOneUser(req, res){
        try {
            let userId = +req.payload.id;
            console.log(userId);
            if (req.payload.role === 'admin' || !isNaN(userId)) {
                userId = +req.params.id;
                console.log(userId);
            }
            if(isNaN(userId)){
                res.status(400).send('Введите корректный id');
            } 
            else{
                const user = await UsersCASL.findOne({
                    where: {
                        id: userId,
                    },
                    attributes: ['id', 'username', 'email', 'role'],
                });
                if (user) {
                    res.status(200).end(JSON.stringify(user, null, 4));
                }
                 else {
                    res.status(404).send('Нет пользователя с таким id');
                }
            }
        }
        catch(err){
            console.log(err);
            res.status(403).send('У вас нет разрешения на просмотр данного пользователя или ваш токен истек');
        }
    }
}

module.exports = new UserController();