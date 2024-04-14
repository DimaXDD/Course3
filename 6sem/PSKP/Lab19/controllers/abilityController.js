class AbilityController {
    async getAllRules(req, res) {
        res.status(200).end(JSON.stringify(req.ability.rules, null, 4));
    }
}

module.exports = new AbilityController();