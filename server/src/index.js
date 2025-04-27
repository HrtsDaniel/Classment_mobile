const express = require('express');
const cors = require('cors');
const userRoutes = require("./routes/user.routes.js");
const schoolRoutes = require("./routes/school.routes.js");
const courseRoutes = require("./routes/course.routes.js");
const classRoutes = require('./routes/class.routes'); 
const enrollmentRoutes = require("./routes/enrollment.routes");
const errorHandler = require("./middleware/errorHandler.js");

const app = express();

// Configuración de CORS
app.use(cors({
  origin: '*',
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

app.use(express.json());

// Rutas existentes
app.use('/api', userRoutes);

// Nuevas rutas para escuelas y cursos
app.use('/api/schools', schoolRoutes);
app.use('/api/courses', courseRoutes);
app.use('/api/classes', classRoutes);
app.use("/api/enrollments", enrollmentRoutes);


// Manejo de rutas no encontradas
app.use((req, res, next) => {
  const error = new Error("Ruta no encontrada");
  error.statusCode = 404;
  next(error);
});

// Middleware de manejo de errores
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});