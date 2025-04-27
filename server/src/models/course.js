"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
    class Course extends Model {
        static associate(models) {
            Course.belongsTo(models.School, {foreignKey: "school_id", as: "school"});

            Course.hasMany(models.Class, {foreignKey: "course_id", as:  "classes"});
        }
    }
    Course.init(
        {
            course_id: {
                type: DataTypes.UUID,
                defaultValue: DataTypes.UUIDV4,
                primaryKey: true,
            },
            school_id: {
                type: DataTypes.UUID,
                allowNull: false,
            },
            course_name: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            course_description: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            course_price: {
                type: DataTypes.DECIMAL,
                allowNull: false,
            },
            course_places: {
                type: DataTypes.INTEGER,
                allowNull: false,
            },
            course_age: {
                type: DataTypes.INTEGER,
                allowNull: false,
            },
            course_image: {
                type: DataTypes.STRING,
                allowNull: false,
            },
        },
        {
            sequelize,
            modelName: "Course",
            timestamps: true,
        }
    );
    return Course;
};
