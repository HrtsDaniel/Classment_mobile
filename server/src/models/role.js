"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
    class Role extends Model {}
    Role.init(
        {
            role_id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            role_name: {
                type: DataTypes.STRING,
                allowNull: false,
            },
        },
        {
            sequelize,
            modelName: "Role",
            timestamps: false,
        }
    );
    return Role;
};
