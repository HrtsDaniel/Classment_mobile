class Enrollment {
  final String userId;
  final String courseId;
  final String startDate;
  final String endDate;
  final String status;

  Enrollment({
    required this.userId,
    required this.courseId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      userId: json['user_id'],
      courseId: json['course_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
    );
  }
}
