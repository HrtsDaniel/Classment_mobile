"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
    class UserCourse extends Model {}
    UserCourse.init(
        {
            user_id: {
                type: DataTypes.UUID,
                allowNull: false,
            },
            course_id: {
                type: DataTypes.UUID,
                allowNull: false,
            },
            course_plan: {
                type: DataTypes.ENUM("anual", "mensual", "semestral", "trimestral"),
                allowNull: false,
            },
            course_state: {
                type: DataTypes.DATE,
                allowNull: false,
            },
            course_start: {
                type: DataTypes.DATE,
                allowNull: false,
            },
            course_end: {
                type: DataTypes.DATE,
                allowNull: false,
            },
        },
        {
            sequelize,
            modelName: "UserCourse",
            timestamps: true,
        }
    );
    return UserCourse;
};
