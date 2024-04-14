const { Repos, Commits } = require('../models');

class CommitsController {
    async getAllCommitsByRepo(req, res) {
        try {
            req.ability.throwUnlessCan(
                'read',
                await Repos.findByPk(req.params.id)
            );
            const commits = await Commits.findAll({
                include: [
                    {
                        model: Repos,
                        required: true,
                        where: {
                            id: req.params.id,
                        },
                        attributes: [],
                    },
                ],
            });
            return res.status(200).end(JSON.stringify(commits, null, 4));
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to view this repo, or your token has expired.');
        }
    }

    async getOneCommitByRepo(req, res) {
        try {
            req.ability.throwUnlessCan(
                'read',
                await Repos.findByPk(req.params.id)
            );
            const commit = await Commits.findOne({
                where: {
                    id: req.params.commitId,
                },
                include: [
                    {
                        model: Repos,
                        required: true,
                        where: {
                            id: req.params.id,
                        },
                        attributes: [],
                    },
                ],
            });
            if (commit)
                return res.status(200).end(JSON.stringify(commit, null, 4));
            else
                return res.status(404).send('There is no commit with such id.');
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to view this repo, or your token has expired.');
        }
    }

    async createCommitByRepo(req, res) {
        try {
            req.ability.throwUnlessCan(
                'create',
                await Repos.findByPk(req.params.id)
            );
            const commit = await Commits.create({
                message: req.body.message,
                repoId: req.params.id,
            });
            return res.status(201).end(JSON.stringify(commit, null, 4));
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to create commits in this repo, or your token has expired.');
        }
    }

    async updateCommitByRepo(req, res) {
        try {
            req.ability.throwUnlessCan(
                'update',
                await Repos.findByPk(req.params.id)
            );
            await Commits.update(
                {
                    message: req.body.message,
                },
                {
                    where: {
                        id: req.params.commitId,
                    },
                    include: [
                        {
                            model: Repos,
                            required: true,
                            where: {
                                id: req.params.id,
                            },
                            attributes: [],
                        },
                    ],
                }
            );

            const commit = await Commits.findOne(
                { where: { id: req.params.commitId } });
            return res.status(200).end(JSON.stringify(commit, null, 4));
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to update commits in this repo, or your token has expired.');
        }
    }

    async deleteCommitByRepo(req, res) {
        try {
            req.ability.throwUnlessCan('manage', 'all');
            const commit = await Commits.findOne(
                { where: { id: req.params.commitId } });

            await Commits.destroy({
                where: {
                    id: req.params.commitId,
                },
                include: [
                    {
                        model: Repos,
                        required: true,
                        where: {
                            id: req.params.id,
                        },
                        attributes: [],
                    },
                ],
            });

            if (commit)
                return res.status(200).end(JSON.stringify(commit, null, 4));
            else
                return res.status(404).send('There is no commit with such id');
        } catch (err) {
            console.log(err);
            res.status(403).send('You dont have permissions to delete commits in this repo, or your token has expired.');
        }
    }
}

module.exports = new CommitsController();