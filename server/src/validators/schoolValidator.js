const { body } = require("express-validator")

exports.createSchoolValidator = [
  body("teacher_id").notEmpty().withMessage("El ID del profesor es requerido"),
  body("school_name").notEmpty().withMessage("El nombre de la escuela es requerido"),
  body("school_description").notEmpty().withMessage("La descripción de la escuela es requerida"),
  body("school_phone")
    .notEmpty()
    .withMessage("El teléfono de la escuela es requerido")
    .isNumeric()
    .withMessage("El teléfono debe ser numérico"),
  body("school_address").notEmpty().withMessage("La dirección de la escuela es requerida"),
  body("school_image").notEmpty().withMessage("La imagen de la escuela es requerida"),
  body("school_email")
    .notEmpty()
    .withMessage("El email de la escuela es requerido")
    .isEmail()
    .withMessage("Debe ser un email válido"),
]

exports.updateSchoolValidator = [
  body("school_name").optional().notEmpty().withMessage("El nombre de la escuela no puede estar vacío"),
  body("school_description").optional().notEmpty().withMessage("La descripción de la escuela no puede estar vacía"),
  body("school_phone").optional().isNumeric().withMessage("El teléfono debe ser numérico"),
  body("school_email").optional().isEmail().withMessage("Debe ser un email válido"),
]
