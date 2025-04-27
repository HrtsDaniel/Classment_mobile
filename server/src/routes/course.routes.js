const express = require('express');
const router = express.Router();
const courseController = require('../controllers/courseController');

// Rutas para cursos
router.get('/', courseController.getAllCourses);
router.get('/school/:schoolId', courseController.getCoursesBySchoolId);
router.get('/:id', courseController.getCourseById);
router.get('/:id/school', courseController.getSchoolNameByCourseId);
router.post('/', courseController.createCourse);
router.put('/:id', courseController.updateCourse);
router.delete('/:id', courseController.deleteCourse);


module.exports = router;