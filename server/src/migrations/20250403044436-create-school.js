"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable("Schools", {
            school_id: {
                type: Sequelize.UUID,
                defaultValue: Sequelize.UUIDV4,
                primaryKey: true,
                allowNull: false,
            },
            teacher_id: {
                type: Sequelize.UUID,
                allowNull: false,
            },
            school_name: {
                type: Sequelize.STRING,
                allowNull: false,
            },
            school_description: {
                type: Sequelize.STRING,
                allowNull: false,
            },
            school_phone: {
                type: Sequelize.DECIMAL,
                allowNull: false,
            },
            school_address: {
                type: Sequelize.STRING,
                allowNull: false,
            },
            school_image: {
                type: Sequelize.STRING,
                allowNull: false,
            },
            school_email: {
                type: Sequelize.STRING,
                allowNull: false,
            },
            createdAt: {
                type: Sequelize.DATE,
                defaultValue: Sequelize.NOW,
                allowNull: false,
            },
            updatedAt: {
                type: Sequelize.DATE,
                defaultValue: Sequelize.NOW,
                onUpdate: Sequelize.NOW,
                allowNull: false,
            },
        });
    },
    async down(queryInterface, Sequelize) {
        await queryInterface.dropTable("Schools");
    },
};
