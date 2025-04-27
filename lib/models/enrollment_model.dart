class Enrollment {
  final String enrollmentId; // Añadir ID de la inscripción
  final String userId;
  final String courseId;
  final DateTime startDate; // Usar DateTime en lugar de String
  final DateTime endDate;
  final String status;
  final DateTime createdAt; // Para tracking
  final DateTime updatedAt;

  Enrollment({
    required this.enrollmentId,
    required this.userId,
    required this.courseId,
    required this.startDate,
    required this.endDate,
    this.status = 'active', // Valor por defecto
    required this.createdAt,
    required this.updatedAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      enrollmentId: json['enrollment_id'] ?? '',
      userId: json['user_id'],
      courseId: json['course_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enrollment_id': enrollmentId,
      'user_id': userId,
      'course_id': courseId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Métodos útiles
  bool get isActive => status == 'active';
  Duration get duration => endDate.difference(startDate);
}