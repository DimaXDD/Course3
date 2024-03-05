const DB = require('../database/db');
const url = require('url');

class auditoriumsTypesAPI {
  async select(req, res) {
    let response;
    let sequelize = new DB();

    try {
      await sequelize.client_connect();
      response = await sequelize.auditoriumType.findAll();
    } catch (e) {
      console.error("Error executing query", e);
      response = { error: "Internal Server Error" };
      res.status(500).json(response);
      return;
    }

    await sequelize.close_connection();
    res.status(200).json(response);
  }

  async selectWithParam(req, res) {
    let response;
    const { id } = req.params;

    console.log(id);
    let sequelize = new DB();

    try {
      await sequelize.client_connect();
      const auditoriums = await sequelize.auditorium.findAll({
        include: [
          {
            model: sequelize.auditoriumType,
            where: { AUDITORIUM_TYPE: id },
          },
        ],
      });

      if (!auditoriums || auditoriums.length === 0) {
        response = { error: "Auditoriums not found" };
        res.status(404).json(response);
        return;
      }

      response = auditoriums;
    } catch (e) {
      console.error("Error executing query", e);
      response = { error: "Internal Server Error" };
      res.status(500).json(response);
      return;
    }

    await sequelize.close_connection();
    res.status(200).json(response);
  }

  async insert(req, res) {
    let response;
    const { AUDITORIUM_TYPE, AUDITORIUM_TYPENAME } = req.body;

    let sequelize = new DB();

    try {
      await sequelize.client_connect();
      await sequelize.auditoriumType.create({
        AUDITORIUM_TYPE: AUDITORIUM_TYPE,
        AUDITORIUM_TYPENAME: AUDITORIUM_TYPENAME,
      });
      response = { message: "Insert successful" };
    } catch (e) {
      console.error("Error executing query", e);
      response = { error: "Failed to insert auditorium type" };
      res.status(500).json(response);
      return;
    }

    await sequelize.close_connection();
    res.status(200).json(response);
  }

  async update(req, res) {
    let response;
    const { AUDITORIUM_TYPE, AUDITORIUM_TYPENAME } = req.body;

    let sequelize = new DB();

    try {
      await sequelize.client_connect();
      await sequelize.auditoriumType.update(
        { AUDITORIUM_TYPENAME: AUDITORIUM_TYPENAME },
        { where: { AUDITORIUM_TYPE: AUDITORIUM_TYPE } }
      );
      response = { message: "Update successful" };
    } catch (e) {
      console.error("Error executing query", e);
      response = { error: "Failed to update auditorium type" };
      res.status(500).json(response);
      return;
    }

    await sequelize.close_connection();
    res.status(200).json(response);
  }

  async delete(req, res) {
    let response;
    const { id } = req.params;

    let sequelize = new DB();

    try {
      await sequelize.client_connect();
      await sequelize.auditoriumType.destroy({
        where: { AUDITORIUM_TYPE: id },
      });
      response = { message: "Delete successful" };
    } catch (e) {
      console.error("Error executing query", e);
      response = { error: "Failed to delete auditorium type" };
      res.status(500).json(response);
      return;
    }

    await sequelize.close_connection();
    res.status(200).json(response);
  }
}

module.exports = new auditoriumsTypesAPI();
