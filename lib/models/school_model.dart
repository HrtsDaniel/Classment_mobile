
class Escuela {
  final String schoolId;
  final String teacherId;
  final String? schoolName;
  final String schoolDescription;
  final String schoolPhone;
  final String schoolAddress;
  final String schoolImage;
  final String schoolEmail;

  Escuela({
    required this.schoolId,
    required this.teacherId,
    required this.schoolName,
    required this.schoolDescription,
    required this.schoolPhone,
    required this.schoolAddress,
    required this.schoolImage,
    required this.schoolEmail,
  });

  factory Escuela.fromJson(Map<String, dynamic> json) {
    return Escuela(
      schoolId: json['school_id'],
      teacherId: json['teacher_id'],
      schoolName: json['school_name'] ?? '',
      schoolDescription: json['school_description'],
      schoolPhone: json['school_phone'].toString(),
      schoolAddress: json['school_address'],
      schoolImage: json['school_image'],
      schoolEmail: json['school_email'],
    );
  }
}

class EscuelaCurso {
  final String schoolName;

  EscuelaCurso({required this.schoolName});

  factory EscuelaCurso.fromJson(Map<String, dynamic> json) {
    return EscuelaCurso(
      schoolName: json['school_name'] ?? 'Escuela no disponible',
    );
  }
}