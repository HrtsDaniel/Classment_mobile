const { School, Course, User, UserSchool } = require('../models');
const asyncHandler = require('../middleware/asyncHandler');

// Obtener todas las escuelas
exports.getAllSchools = asyncHandler(async (req, res) => {
  const schools = await School.findAll();
  
  return res.status(200).json({
    success: true,
    data: schools
  });
});

// Obtener una escuela por ID con sus cursos
exports.getSchoolById = asyncHandler(async (req, res) => {
  const { id } = req.params;
  
  const school = await School.findByPk(id, {
    include: [{ 
      model: Course, 
      as: 'courses'
    }]
  });
  
  if (!school) {
    const error = new Error('Escuela no encontrada');
    error.statusCode = 404;
    throw error;
  }
  
  return res.status(200).json({
    success: true,
    data: school
  });
});

// Crear una nueva escuela
exports.createSchool = asyncHandler(async (req, res) => {
  const { school_name, school_description, school_phone, school_address, school_image, school_email } = req.body;
  const coordinator_id = req.user.user_id;

  // Verificar que el usuario es un coordinador
  const coordinator = await User.findByPk(coordinator_id);
  if (!coordinator || coordinator.role_id !== 4) {
    const error = new Error('Solo los coordinadores pueden crear escuelas');
    error.statusCode = 403;
    throw error;
  }

  // Crear la escuela
  const school = await School.create({
    school_name,
    school_description,
    school_phone,
    school_address,
    school_image,
    school_email,
    teacher_id: coordinator_id
  });

  // Crear la relación entre el coordinador y la escuela
  await UserSchool.create({
    user_id: coordinator_id,
    school_id: school.school_id,
    is_owner: true
  });

  return res.status(201).json({
    success: true,
    data: school,
    message: "Escuela creada exitosamente"
  });
});

// Actualizar una escuela existente
exports.updateSchool = asyncHandler(async (req, res) => {
  const { id } = req.params;
  const coordinator_id = req.user.user_id;
  const updateData = req.body;

  // Verificar que el usuario es el coordinador de la escuela
  const userSchool = await UserSchool.findOne({
    where: {
      school_id: id,
      user_id: coordinator_id,
      is_owner: true
    }
  });

  if (!userSchool) {
    const error = new Error('No tienes permisos para modificar esta escuela');
    error.statusCode = 403;
    throw error;
  }

  const school = await School.findByPk(id);
  if (!school) {
    const error = new Error('Escuela no encontrada');
    error.statusCode = 404;
    throw error;
  }

  await school.update(updateData);

  return res.status(200).json({
    success: true,
    data: school,
    message: "Escuela actualizada correctamente"
  });
});

// Eliminar una escuela
exports.deleteSchool = asyncHandler(async (req, res) => {
  const { id } = req.params;
  const coordinator_id = req.user.user_id;

  // Verificar que el usuario es el coordinador de la escuela
  const userSchool = await UserSchool.findOne({
    where: {
      school_id: id,
      user_id: coordinator_id,
      is_owner: true
    }
  });

  if (!userSchool) {
    const error = new Error('No tienes permisos para eliminar esta escuela');
    error.statusCode = 403;
    throw error;
  }

  const school = await School.findByPk(id);
  if (!school) {
    const error = new Error('Escuela no encontrada');
    error.statusCode = 404;
    throw error;
  }

  await school.destroy();

  return res.status(200).json({
    success: true,
    message: "Escuela eliminada correctamente"
  });
});

// Obtener escuelas del coordinador
exports.getCoordinatorSchools = asyncHandler(async (req, res) => {
  const coordinator_id = req.user.user_id;

  const schools = await School.findAll({
    include: [
      {
        model: User,
        as: "coordinators",
        where: { user_id: coordinator_id },
        attributes: ["user_id", "user_name", "user_lastname", "user_email"]
      }
    ]
  });

  return res.status(200).json({
    success: true,
    data: schools,
    message: "Escuelas del coordinador obtenidas correctamente"
  });
});