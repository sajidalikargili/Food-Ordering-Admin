class AdminModel {
  final String name;
  final String email;

  AdminModel({
    required this.name,
    required this.email,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}