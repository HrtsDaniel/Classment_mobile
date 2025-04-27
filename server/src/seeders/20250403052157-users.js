"use strict";
const { users, roles } = require("./data.json");

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        /**
         * Add seed commands here.
         */
        await queryInterface.bulkInsert("Users", users, {});
        await queryInterface.bulkInsert("Roles", roles, {});
    },

    async down(queryInterface, Sequelize) {
        /**
         * Add commands to revert seed here.
         */
        await queryInterface.bulkDelete("Users", null, {});
        await queryInterface.bulkDelete("Roles", null, {});
    },
};
