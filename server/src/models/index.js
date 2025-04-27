const { Sequelize, DataTypes } = require("sequelize");
const { development: config } = require("../config/config.json");

const connection = new Sequelize(config.database, config.username, config.password, {
    host: config.host,
    dialect: config.dialect,
    dialectModule: require("mysql2"),
    logging: false,
});

(async () => {
    try {
        await connection.authenticate();
        console.log("Base de datos conectada exitosamente");
    } catch (error) {
        console.log("Error al conectar a la base de datos", error);
    }
})();

const UserModel = require("./user.js");
const RoleModel = require("./role.js");
const CourseModel = require("./course.js");
const SchoolModel = require("./school.js");
const UserCourseModel = require("./usercourse.js");
const UserSchoolModel = require("./userschool.js");
const ClassModel = require("./Class.js");
const EnrollmentModel = require("./enrollment.js");

const User = UserModel(connection, DataTypes);
const Role = RoleModel(connection, DataTypes);
const Course = CourseModel(connection, DataTypes);
const School = SchoolModel(connection, DataTypes);
const UserCourse = UserCourseModel(connection, DataTypes);
const UserSchool = UserSchoolModel(connection, DataTypes);
const Class = ClassModel(connection, DataTypes);
const Enrollment = EnrollmentModel(connection, DataTypes);

Role.hasMany(User, { as: "users", foreignKey: "role_id" });
User.belongsTo(Role, { as: "role", foreignKey: "role_id" });

School.hasMany(Course, { as: "courses", foreignKey: "school_id" });
Course.belongsTo(School, { as: "school", foreignKey: "school_id" });

Course.belongsToMany(User, { through: UserCourse, as: "students", foreignKey: "course_id" });
User.belongsToMany(Course, { through: UserCourse, as: "courses", foreignKey: "user_id" });

// Relaciones para UserSchool
User.belongsToMany(School, { through: UserSchool, as: "managedSchools", foreignKey: "user_id" });
School.belongsToMany(User, { through: UserSchool, as: "coordinators", foreignKey: "school_id" });

module.exports = {
    User,
    Role,
    Course,
    School,
    UserCourse,
    UserSchool,
    connection,
};

Course.hasMany(Class, { as: "classes", foreignKey: "course_id" });
Class.belongsTo(Course, { as: "course", foreignKey: "course_id" });

module.exports = {
    User,
    Role,
    Course,
    School,
    UserCourse,
    UserSchool,
    Class, 
    connection,
};

// Relación: Un usuario puede tener muchas matrículas
User.hasMany(Enrollment, { as: "enrollments", foreignKey: "user_id" });
Enrollment.belongsTo(User, { as: "user", foreignKey: "user_id" });

// Relación: Un curso puede tener muchas matrículas
Course.hasMany(Enrollment, { as: "enrollments", foreignKey: "course_id" });
Enrollment.belongsTo(Course, { as: "course", foreignKey: "course_id" });

module.exports = {
    User,
    Role,
    Course,
    School,
    UserCourse,
    UserSchool,
    Class,
    Enrollment, // Exporta el modelo Enrollment
    connection,
};