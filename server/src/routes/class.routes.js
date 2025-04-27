const express = require('express');
const router = express.Router();
const classController = require('../controllers/classController');

// Ruta para obtener clases por course_id
router.get('/course/:courseId', classController.getClassesByCourseId);

module.exports = router;