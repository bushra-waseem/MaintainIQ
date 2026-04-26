class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photo;
  final bool emailVerified;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photo,
    required this.emailVerified,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photo: map['photo'],
      emailVerified: map['emailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photo': photo,
      'emailVerified': emailVerified,
    };
  }
}