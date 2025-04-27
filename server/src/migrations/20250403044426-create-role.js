"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable("Roles", {
            role_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            role_name: {
                type: Sequelize.STRING,
            },
        });
    },
    async down(queryInterface, Sequelize) {
        await queryInterface.dropTable("Roles");
    },
};
