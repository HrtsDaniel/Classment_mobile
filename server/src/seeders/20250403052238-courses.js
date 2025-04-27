"use strict";
const { courses, schools, usercourses } = require("./data.json");

/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        /**
         * Add seed commands here.
         */
        await queryInterface.bulkInsert("Courses", courses, {});
        await queryInterface.bulkInsert("Schools", schools, {});
        await queryInterface.bulkInsert("UserCourses", usercourses, {});
    },

    async down(queryInterface, Sequelize) {
        /**
         * Add commands to revert seed here.
         */
        await queryInterface.bulkDelete("Courses", null, {});
        await queryInterface.bulkDelete("Schools", null, {});
        await queryInterface.bulkDelete("UserCourses", null, {});
        
    },
};
