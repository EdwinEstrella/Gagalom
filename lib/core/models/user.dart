class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? ageRange;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.ageRange,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'] as String,
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      gender: json['gender'] as String?,
      ageRange: json['ageRange'] ?? json['age_range'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'ageRange': ageRange,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName'.trim();

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? ageRange,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
