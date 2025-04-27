const { body } = require("express-validator")

exports.createCourseValidator = [
  body("school_id").notEmpty().withMessage("El ID de la escuela es requerido"),
  body("course_name").notEmpty().withMessage("El nombre del curso es requerido"),
  body("course_description").notEmpty().withMessage("La descripción del curso es requerida"),
  body("course_price")
    .notEmpty()
    .withMessage("El precio del curso es requerido")
    .isNumeric()
    .withMessage("El precio debe ser numérico"),
  body("course_places")
    .notEmpty()
    .withMessage("El número de plazas es requerido")
    .isInt({ min: 1 })
    .withMessage("Las plazas deben ser un número entero positivo"),
  body("course_age")
    .notEmpty()
    .withMessage("La edad requerida es requerida")
    .isInt({ min: 0 })
    .withMessage("La edad debe ser un número entero positivo"),
  body("course_image").notEmpty().withMessage("La imagen del curso es requerida"),
]

exports.updateCourseValidator = [
  body("course_name").optional().notEmpty().withMessage("El nombre del curso no puede estar vacío"),
  body("course_description").optional().notEmpty().withMessage("La descripción del curso no puede estar vacía"),
  body("course_price").optional().isNumeric().withMessage("El precio debe ser numérico"),
  body("course_places").optional().isInt({ min: 1 }).withMessage("Las plazas deben ser un número entero positivo"),
  body("course_age").optional().isInt({ min: 0 }).withMessage("La edad debe ser un número entero positivo"),
]
