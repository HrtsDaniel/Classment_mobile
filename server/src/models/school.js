"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
    class School extends Model {
        static associate(models) {
            School.hasMany(models.Course, {foreignKey: "school_id", as: "courses"});
        }
    }
    School.init(
        {
            school_id: {
                type: DataTypes.UUID,
                defaultValue: DataTypes.UUIDV4,
                primaryKey: true,
            },
            teacher_id: {
                type: DataTypes.UUID,
                allowNull: false,
            },
            school_name: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            school_description: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            school_phone: {
                type: DataTypes.DECIMAL,
                allowNull: false,
            },
            school_address: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            school_image: {
                type: DataTypes.STRING,
                allowNull: false,
            },
            school_email: {
                type: DataTypes.STRING,
                allowNull: false,
            }
        },
        {
            sequelize,
            modelName: "School",
            timestamps: true,
        }
    );
    return School;
};
