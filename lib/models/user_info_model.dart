class UserEnrollmentInfo {
  final DateTime startDate;
  final DateTime endDate;
  final String courseName;
  final String schoolName;
  final String schoolAddress;

  UserEnrollmentInfo({
    required this.startDate,
    required this.endDate,
    required this.courseName,
    required this.schoolName,
    required this.schoolAddress,
  });

  factory UserEnrollmentInfo.fromJson(Map<String, dynamic> json) {
  return UserEnrollmentInfo(
    startDate: DateTime.parse(json['start_date']),
    endDate: DateTime.parse(json['end_date']),
    courseName: json['course']?['course_name'] ?? 'Sin nombre',
    schoolName: json['course']?['school']?['school_name'] ?? 'Sin escuela',
    schoolAddress: json['course']?['school']?['school_address'] ?? 'Sin dirección',
  );
}
}