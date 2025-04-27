const { Router } = require("express");
const UserController = require("../controllers/userController.js");
const { verifyToken } = require("../middleware/auth.js"); 

const userRoutes = Router();

// CRUD
userRoutes.get("/users", UserController.getUsers);
userRoutes.get("/users/:id", UserController.getUser);
userRoutes.post("/users", UserController.createUser);
userRoutes.put("/users/:id", UserController.updateUser);
userRoutes.delete("/users/:id", UserController.deleteUser);

// Login    
userRoutes.post("/login", UserController.login);

// Rutas para recuperación de contraseña
userRoutes.post("/forgot-password", UserController.forgotPassword);
userRoutes.post("/reset-password", UserController.resetPassword);

// Ruta para validar token
userRoutes.get("/auth/me", verifyToken, UserController.validateToken);

// Rutas para obtener cursos y escuelas del usuario
userRoutes.get("/users/:id/courses", UserController.getUserCourses);
userRoutes.get("/users/:id/schools", UserController.getUserSchools);

module.exports = userRoutes;