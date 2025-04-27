const { Class } = require('../models'); // Importa el modelo Class
const asyncHandler = require('express-async-handler');

// Obtener clases por course_id
exports.getClassesByCourseId = asyncHandler(async (req, res) => {
  const { courseId } = req.params;

  // Buscar las clases asociadas al course_id
  const classes = await Class.findAll({
    where: { course_id: courseId },
    attributes: ['class_id', 'class_title', 'class_description', 'class_date', 'duration'], // Campos que deseas devolver
  });

  if (classes.length === 0) {
    return res.status(404).json({ message: 'No se encontraron clases para este curso.' });
  }

  return res.status(200).json({
    success: true,
    data: classes,
  });
});