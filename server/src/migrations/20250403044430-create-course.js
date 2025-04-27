"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable("Courses", {
            course_id: {
                type: Sequelize.UUID,
                defaultValue: Sequelize.UUIDV4,
                primaryKey: true,
            },
            school_id: {
                type: Sequelize.UUID,
                allowNull: false,
            },
            course_name: {
                type: Sequelize.STRING,
                allowNull: false,
            },
            course_description: {
                type: Sequelize.STRING,
                allowNull: false,
            },
            course_price: {
                type: Sequelize.DECIMAL,
                allowNull: false,
            },
            course_places: {
                type: Sequelize.INTEGER,
                allowNull: false,
            },
            course_age: {
                type: Sequelize.INTEGER,
                allowNull: false,
            },
            course_image: {
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
        await queryInterface.dropTable("Courses");
    },
};
