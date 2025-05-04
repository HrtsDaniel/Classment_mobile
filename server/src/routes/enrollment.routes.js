const express = require("express");
const router = express.Router();
const enrollmentController = require("../controllers/enrollmentController");

// Ruta para agendar una clase
router.post("/schedule-class", enrollmentController.scheduleClass);

// Ruta para obtener la información de las clases de un usuario
router.get("/user-info/:userId", enrollmentController.getUserInfo);

// Ruta para eliminar una inscripción por enrollment_id
router.delete("/", enrollmentController.deleteEnrollment);

module.exports = router;