"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Class extends Model {
    static associate(models) {
      // Relación: Una clase pertenece a un curso
      Class.belongsTo(models.Course, { foreignKey: "course_id", as: "course" });
    }
  }
  Class.init(
    {
      class_id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      course_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      class_title: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      class_description: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      class_date: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      duration: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      sequelize,
      modelName: "Class",
      timestamps: true,
    }
  );
  return Class;
};