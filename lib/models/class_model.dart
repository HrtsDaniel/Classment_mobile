class ClassModel {
  final String classId;
  final String courseId;
  final String classTitle;
  final String? classDescription;
  final DateTime classDate;
  final int duration;

  ClassModel({
    required this.classId,
    required this.courseId,
    required this.classTitle,
    this.classDescription,
    required this.classDate,
    required this.duration,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classId: json['class_id'] as String? ?? '',
      courseId: json['course_id'] as String? ?? '',
      classTitle: json['class_title'] as String? ?? 'Clase sin título',
      classDescription: json['class_description'] as String? ?? '',
      classDate: DateTime.parse(json['class_date']) ,
      duration: json['duration'],
    );
  }
}