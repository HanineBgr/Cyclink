class User {
  final String id;
  final String email;
  final String name;
  final String? gender;
  final DateTime? dateOfBirth;
  final double? weight;
  final double? height;
  final int ftp;
  final int? maxHR;
  final int? restingHR;
  final Map<String, dynamic>? preferences;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.gender,
    this.dateOfBirth,
    this.weight,
    this.height,
    required this.ftp,
    this.maxHR,
    this.restingHR,
    this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      weight: json['weight'] != null ? (json['weight']).toDouble() : null,
      height: json['height'] != null ? (json['height']).toDouble() : null,
      ftp: json['ftp'] ?? 0,
      maxHR: json['max_hr'],
      restingHR: json['resting_hr'],
      preferences: json['preferences'],
    );
  }
}
