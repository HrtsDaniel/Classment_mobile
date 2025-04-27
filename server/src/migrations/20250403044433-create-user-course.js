"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        await queryInterface.createTable("UserCourses", {
            user_id: {
                type: Sequelize.UUID,
                allowNull: false,
            },
            course_id: {
                type: Sequelize.UUID,
                allowNull: false,
            },
            course_plan: {
                type: Sequelize.ENUM("anual", "mensual", "semestral", "trimestral"),
                allowNull: false,
            },
            course_state: {
                type: Sequelize.DATE,
                allowNull: false,
            },
            course_start: {
                type: Sequelize.DATE,
                allowNull: false,
            },
            course_end: {
                type: Sequelize.DATE,
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
        await queryInterface.dropTable("UserCourses");
    },
};
