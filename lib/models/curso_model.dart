class Course {
  final String courseId;
  final String schoolId;
  final String courseName;
  final String courseDescription;
  final double coursePrice;
  final int coursePlaces;
  final int courseAge;
  final String courseImage;

  Course({
    required this.courseId,
    required this.schoolId,
    required this.courseName,
    required this.courseDescription,
    required this.coursePrice,
    required this.coursePlaces,
    required this.courseAge,
    required this.courseImage,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'],
      schoolId: json['school_id'],
      courseName: json['course_name'],
      courseDescription: json['course_description'],
      coursePrice: double.parse(json['course_price'].toString()),
      coursePlaces: json['course_places'],
      courseAge: json['course_age'],
      courseImage: json['course_image'],
    );
  }
}