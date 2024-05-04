class ProfileModel {
  final String userName;
  final String name;
  final String email;

  ProfileModel({
    required this.userName,
    required this.name,
    required this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userName: json['username'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'name': name,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'ProfileModel(userName: $userName, name: $name, email: $email)';
  }
}
