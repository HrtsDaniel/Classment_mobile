const jwt = require('jsonwebtoken');
const { User } = require("../models");

const verifyToken = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "No se proporcionó token de acceso"
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET || "fullsecret");
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: "Token inválido o expirado"
    });
  }
};

// Middleware para verificar roles
const checkRole = (roles) => {
  return async (req, res, next) => {
    try {
      const user = await User.findOne({
        where: { user_id: req.user.user_id }
      });

      if (!user) {
        return res.status(404).json({
          success: false,
          message: "Usuario no encontrado"
        });
      }

      // Roles: 1 = estudiante, 3 = administrador, 4 = coordinador
      if (!roles.includes(user.role_id)) {
        return res.status(403).json({
          success: false,
          message: "No tienes permiso para acceder a este recurso"
        });
      }

      next();
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Error al verificar rol",
        error: error.message
      });
    }
  };
};

module.exports = { verifyToken, checkRole };