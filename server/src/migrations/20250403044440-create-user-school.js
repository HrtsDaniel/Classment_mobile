"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
    async up(queryInterface, Sequelize) {
        // Primero creamos la tabla sin las restricciones
        await queryInterface.createTable("UserSchools", {
            user_id: {
                type: Sequelize.UUID,
                allowNull: false
            },
            school_id: {
                type: Sequelize.UUID,
                allowNull: false
            },
            is_owner: {
                type: Sequelize.BOOLEAN,
                defaultValue: false,
                allowNull: false
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
            }
        });

        // Luego agregamos las restricciones de clave foránea
        await queryInterface.addConstraint('UserSchools', {
            fields: ['user_id'],
            type: 'foreign key',
            name: 'fk_userschool_user',
            references: {
                table: 'Users',
                field: 'user_id'
            },
            onDelete: 'CASCADE',
            onUpdate: 'CASCADE'
        });

        await queryInterface.addConstraint('UserSchools', {
            fields: ['school_id'],
            type: 'foreign key',
            name: 'fk_userschool_school',
            references: {
                table: 'Schools',
                field: 'school_id'
            },
            onDelete: 'CASCADE',
            onUpdate: 'CASCADE'
        });

        // Agregamos la clave primaria compuesta
        await queryInterface.addConstraint('UserSchools', {
            fields: ['user_id', 'school_id'],
            type: 'primary key',
            name: 'pk_userschool'
        });

        // Finalmente agregamos el índice único
        await queryInterface.addIndex('UserSchools', ['user_id', 'school_id'], {
            unique: true,
            name: 'idx_userschool_unique'
        });
    },
    async down(queryInterface, Sequelize) {
        await queryInterface.dropTable("UserSchools");
    },
}; 