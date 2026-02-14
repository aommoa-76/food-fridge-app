class User {
  final String id;
  final String name;
  final String email;
  final String? password; //null ได้ถ้าเป็น google
  final String provider; //email or google

  User ({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.provider,
  });

  // User Obj -> SQlite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,  
      'provider': provider,
    };
  }

  // SQlite -> User Obj
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      provider: map['provider'],
    );
  }
}


