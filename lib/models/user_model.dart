class User {
  final String? userId;
  final String userName;
  final String userLastname;
  final String userDocumentType;
  final String userDocument;
  final String userEmail;
  final String userPassword;
  final String userPhone;
  final String userImage;
  final String userBirth;
  final String? userState;
  final int roleId;

  User({
    required this.userId,
    required this.userName,
    required this.userLastname,
    required this.userDocumentType,
    required this.userDocument,
    required this.userEmail,
    required this.userPassword,
    required this.userPhone,
    required this.userImage,
    required this.userBirth,
    this.userState = 'activo',
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      'user_name': userName,
      'user_lastname': userLastname,
      'user_document_type': userDocumentType,
      'user_document': userDocument,
      'user_email': userEmail,
      'user_password': userPassword,
      'user_phone': userPhone,
      'user_image': userImage,
      'user_birth': userBirth,
      'user_state': userState,
      'role_id': roleId,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userLastname: json['user_lastname'] ?? '',
      userDocumentType: json['user_document_type'] ?? '',
      userDocument: json['user_document'] ?? '',
      userEmail: json['user_email'] ?? '',
      userPassword: json['user_password'] ?? '',
      userPhone: json['user_phone'].toString() ?? '',
      userImage: json['user_image'] ?? '',
      userBirth: json['user_birth'] ?? '',
      userState: json['user_state'] ?? '',
      roleId: json['role_id'] ?? 1,
    );
  }
}
