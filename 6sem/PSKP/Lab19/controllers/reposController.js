const { Repos } = require('../models');

class ReposController {
    // async getAllRepos(req, res) {
    //     try {
    //         req.ability.throwUnlessCan('manage', 'all');
    //         const repos = await Repos.findAll();
    //         return res.status(200).end(JSON.stringify(repos, null, 4));
    //     } catch (err) {
    //         res.status(403).send('You dont have permissions to view all repos, or your token has expired.');
    //     }
    // }


    async getAllRepos(req, res) {
        try {
            req.ability.throwUnlessCan('read', 'Repos');
            const repos = await Repos.findAll();
            return res.status(200).end(JSON.stringify(repos, null, 4));
        } catch (err) {
            res.status(403).send('You dont have permissions to view all repos, or your token has expired.');
        }
    }
    

    async getOneRepo(req, res) {
        try {
            req.ability.throwUnlessCan(
                'read',
                await Repos.findByPk(req.params.id)
            );
            const repo = await Repos.findOne({
                where: {
                    id: req.params.id
                },
            });

            if (repo) {
                return res.status(200).end(JSON.stringify(repo, null, 4));
            } else {
                return res.status(404).send('Repo is not found.');
            }
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to view this repo, or your token has expired.');
        }
    }

    async createRepo(req, res) {
        try {
            req.ability.throwUnlessCan('create', 'Repos');
            console.log('body: ', req.body);
            const repoExists = await Repos.findOne({
                where: {
                    name: req.body.name,
                    authorId: req.payload.id
                }
            });
            if (repoExists)
                return res.status(409).send('Repo with such name already exists.');
            const repo = await Repos.create({
                name: req.body.name,
                authorId: req.payload.id,
            });
            return res.status(201).end(JSON.stringify(repo, null, 4));
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to create repo, or your token has expired.' + err);
        }
    }

    async updateRepo(req, res) {
        try {
            req.ability.throwUnlessCan(
                'update',
                await Repos.findByPk(req.params.id)
            );
            const repo = await Repos.findOne({
                where: { id: req.params.id, }
            });
            const repoWithSameName = await Repos.findOne({
                where: { name: req.body.name }
            });

            if (repoWithSameName && repoWithSameName.id != req.params.id)
                return res.status(409).send('You already have a repo with such name.');
            if (repo) {
                await Repos.update(
                    { name: req.body.name, },
                    {
                        where: { id: req.params.id, }
                    }
                );

                const repoUpdated = await Repos.findOne(
                    { where: { id: +req.params.id } });
                console.log(repoUpdated);
                console.log(+req.params.id);
                return res.status(200).end(JSON.stringify(repoUpdated, null, 4));
            } else
                res.status(404).send('Repo is not found.');
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to update this repo, or your token has expired.');
        }
    }

    async deleteRepo(req, res) {
        try {
            req.ability.throwUnlessCan('manage', 'all');
            const repo = await Repos.findOne({
                where: {
                    id: req.params.id,
                },
            });
            if (repo) {
                await Repos.destroy({
                    where: {
                        id: req.params.id,
                    },
                });
                return res.status(200).end(JSON.stringify(repo, null, 4));
            } else res.status(404).send('There is no repo with such id.');
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to delete this repo, or your token has expired.');
        }
    }
}

module.exports = new ReposController();