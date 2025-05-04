"use strict";

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert("Classes", [
      {
        class_id: "123e4567-e89b-12d3-a456-426614174000", 
        course_id: "d290f1ee-6c54-4b01-90e6-d701748f0851", 
        teacher_id: "550e8400-e29b-41d4-a716-446655440003",
        class_date: new Date("2025-05-01T10:00:00Z"),
        class_title: "Introducción sobre el Entrenamiento Personal ",
        class_description: "Clase introductoria sobre las reglas y fundamentos sobre el Entrenamiento Personal",
        duration: 60,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        class_id: "123e4567-e89b-12d3-a456-426614174004", 
        course_id: "d290f1ee-6c54-4b01-90e6-d701748f0852", 
        teacher_id: "550e8400-e29b-41d4-a716-446655440003",
        class_date: new Date("2025-05-08T09:00:00Z"),
        class_title: "Fundamentos del rendimiento deportivo",
        class_description: "Clase introductoria sobre los fundamentos básicos del deporte.",
        duration: 60,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        class_id: "123e4567-e89b-12d3-a456-426614174005", 
        course_id: "d290f1ee-6c54-4b01-90e6-d701748f0853", 
        teacher_id: "550e8400-e29b-41d4-a716-446655440003",
        class_date: new Date("2025-05-07T11:00:00Z"),
        class_title: "Técnicas de Defensa Personal",
        class_description: "Exploración de técnicas principiantes para la Defensa Personal.",
        duration: 90,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        class_id: "123e4567-e89b-12d3-a456-426614174006", 
        course_id: "d290f1ee-6c54-4b01-90e6-d701748f0854", 
        teacher_id: "550e8400-e29b-41d4-a716-446655440003",
        class_date: new Date("2025-05-05T14:00:00Z"),
        class_title: "Entrenamineto basico de Fuerza",
        class_description: "Clase introductoria sobre el entrenamiento de fuerza y sus beneficios.",
        duration: 90,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        class_id: "123e4567-e89b-12d3-a456-426614174007", 
        course_id: "d290f1ee-6c54-4b01-90e6-d701748f0855", 
        teacher_id: "550e8400-e29b-41d4-a716-446655440003",
        class_date: new Date("2025-05-06T16:00:00Z"),
        class_title: "Clase de Zumba para principiantes",
        class_description: "Introducción a los aspectos básicos sobre la Zumba.",
        duration: 60,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        class_id: "123e4567-e89b-12d3-a456-426614174008", 
        course_id: "d290f1ee-6c54-4b01-90e6-d701748f0856", 
        teacher_id: "550e8400-e29b-41d4-a716-446655440003",
        class_date: new Date("2025-05-07T18:00:00Z"),
        class_title: "Taekwondo Básico",
        class_description: "Inicio a la práctica del Taekwondo y sus fundamentos.",
        duration: 45,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("Classes", null, {});
  },
};