"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class Enrollment extends Model {
    static associate(models) {
      // Relación: Una matrícula pertenece a un usuario
      Enrollment.belongsTo(models.User, { foreignKey: "user_id", as: "user" });

      // Relación: Una matrícula pertenece a un curso
      Enrollment.belongsTo(models.Course, { foreignKey: "course_id", as: "course" });
    }
  }
  Enrollment.init(
    {
      enrollment_id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      user_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      course_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      start_date: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      end_date: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      status: {
        type: DataTypes.ENUM("active", "inactive"),
        allowNull: false,
        defaultValue: "active",
      },
    },
    {
      sequelize,
      modelName: "Enrollment",
      timestamps: true, // Esto habilita automáticamente createdAt y updatedAt
    }
  );
  return Enrollment;
};