"use strict";
const { Model } = require("sequelize");
const bcrypt = require("bcrypt");

module.exports = (sequelize, DataTypes) => {
    class User extends Model {
        // Método para comparar contraseñas en el login
        async comparePassword(candidatePassword) {
            return await bcrypt.compare(candidatePassword, this.user_password);
        }
    }
    // Definimos el modelo
    User.init(
        {
            user_id: {
                type: DataTypes.UUID,
                defaultValue: DataTypes.UUIDV4,
                primaryKey: true,
            },
            user_name: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    isAlpha: {
                       // msg: "El nombre solo debe contener letras"
                    },
                    notEmpty: {
                        msg: "El nombre es requerido"
                    }
                }
            },
            user_lastname: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    isAlpha: {
                        msg: "El apellido solo debe contener letras"
                    },
                    notEmpty: {
                        msg: "El apellido es requerido"
                    }
                }
            },
            user_document_type: {
                type: DataTypes.ENUM("TI", "CC", "CE"),
                allowNull: false,
                validate: {
                    isIn: {
                        args: [["TI", "CC", "CE"]],
                        msg: "El tipo de documento debe ser TI, CC o CE"
                    }
                }
            },
            user_document: {
                type: DataTypes.DECIMAL,
                allowNull: false,
                validate: {
                    isNumeric: {
                        msg: "El documento debe contener solo números"
                    }
                }
            },
            user_email: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    isEmail: {
                        msg: "Debe proporcionar un email válido"
                    }
                }
            },
            user_password: {
                type: DataTypes.STRING,
                allowNull: false,
                validate: {
                    len: {
                        args: [8, 100],
                        msg: "La contraseña debe tener al menos 8 caracteres"
                    }
                }
            },
            user_phone: {
                type: DataTypes.DECIMAL,
                allowNull: false,
                validate: {
                    isNumeric: {
                        msg: "El teléfono debe contener solo números"
                    }   
                }
            },
            user_image: {
                type: DataTypes.STRING,
                allowNull: false,
                defaultValue:'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'
            },
            user_birth: {
                type: DataTypes.DATEONLY,
                allowNull: false,
                validate: {
                    isDate: {
                        msg: "Debe proporcionar una fecha válida"
                    },
                    notEmpty: {
                        msg: "La fecha de nacimiento es requerida"
                    }
                }
            },
            user_state: {
                type: DataTypes.ENUM('activo', 'inactivo'),
                allowNull: false,
                defaultValue: 'activo'
            },
            role_id: {
                type: DataTypes.INTEGER,
                allowNull: false,
            },
        },
        {
            sequelize,
            modelName: "User",
            timestamps: true,
            hooks: {
                // Hook para encriptar la contraseña antes de guardar
                beforeCreate: async (user) => {
                    if (user.user_password) {
                        const salt = await bcrypt.genSalt(10);
                        user.user_password = await bcrypt.hash(user.user_password, salt);
                    }
                },
                // Hook para encriptar la contraseña antes de actualizar
                beforeUpdate: async (user) => {
                    if (user.changed('user_password')) {
                        const salt = await bcrypt.genSalt(10);
                        user.user_password = await bcrypt.hash(user.user_password, salt);
                    }
                }
            }
        }
    );
    return User;
};