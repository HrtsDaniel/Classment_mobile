const { Enrollment, Course, School } = require("../models");

exports.scheduleClass = async (req, res) => {
  const { user_id, course_id, start_date, end_date } = req.body;

  // Validación de campos
  if (!user_id || !course_id || !start_date || !end_date) {
    return res.status(400).json({ message: "Todos los campos son obligatorios." });
  }

  // Verificar si las fechas son válidas
  const startDate = new Date(start_date);
  const endDate = new Date(end_date);
  if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
    return res.status(400).json({ message: "Las fechas de inicio y fin deben ser válidas." });
  }

  if (startDate >= endDate) {
    return res.status(400).json({ message: "La fecha de inicio debe ser antes de la fecha de fin." });
  }

  try {
    let enrollment = await Enrollment.findOne({ where: { user_id, course_id } });

    if (!enrollment) {
      // Crear una nueva inscripción si no existe
      enrollment = await Enrollment.create({
        user_id,
        course_id,
        start_date: startDate,
        end_date: endDate,
        status: "active", // O usa un estado según tu lógica
      });
    } else {
      // Si ya existe, actualiza las fechas
      enrollment.start_date = startDate;
      enrollment.end_date = endDate;
      await enrollment.save();
    }

    res.status(200).json({
      success: true,
      message: "Clase agendada exitosamente.",
      data: enrollment,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al agendar la clase." });
  }
};

// Controlador para obtener la información de las clases de un usuario
exports.getUserInfo = async (req, res) => {
    const { userId } = req.params;
  
    try {
      // Consulta a la base de datos con relaciones
      const userClasses = await Enrollment.findAll({
        where: { user_id: userId },
        attributes: ["start_date", "end_date"], // Fechas de la tabla Enrollment
        include: [
          {
            model: Course,
            as: "course",
            attributes: ["course_name"], // Nombre del curso
            include: [
              {
                model: School,
                as: "school",
                attributes: ["school_name", "school_address"], // Nombre y dirección de la escuela
              },
            ],
          },
        ],
      });
  
      if (userClasses.length === 0) {
        return res.status(404).json({ message: "No se encontraron clases para este usuario." });
      }
  
      // Responder con los datos
      res.status(200).json({
        success: true,
        data: userClasses,
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Error al obtener la información del usuario." });
    }
  };