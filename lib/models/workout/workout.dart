class Workout {
  final String id;
  final String name;
  final String description;
  final int durationMinutes;
  final int tss;
  final String category;
  final String xml;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.tss,
    required this.category,
    required this.xml,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
     durationMinutes: (json['duration_minutes'] ?? 0).toInt(), 
      tss: (json['tss'] ?? 0).toInt(),
      category: json['category'] ?? '',
      xml: json['xml'] ?? '',
    );
  }
}
