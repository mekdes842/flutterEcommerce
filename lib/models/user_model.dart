class User {
  final int id;
  final String email;
  final String username;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? image;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      firstName: json['name']?['firstname'],
      lastName: json['name']?['lastname'],
      phone: json['phone'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'name': {
        'firstname': firstName,
        'lastname': lastName,
      },
      'phone': phone,
      'image': image,
    };
  }

  String get fullName => '$firstName $lastName'.trim();
}