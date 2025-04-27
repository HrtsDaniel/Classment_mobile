// Middleware para manejo centralizado de errores
const errorHandler = (err, req, res, next) => {
    console.error("Error:", err)
  
    // Determinar el código de estado HTTP
    const statusCode = err.statusCode || 500
  
    // Respuesta de error
    res.status(statusCode).json({
      success: false,
      message: err.message || "Error interno del servidor",
      stack: process.env.NODE_ENV === "production" ? "🥞" : err.stack,
    })
  }
  
  module.exports = errorHandler
  