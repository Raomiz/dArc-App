/// Why people are acting together.
///
/// User-facing word is **Purpose**. This is not an atlas Cycle / Site / Field
/// row — it is a social why, held on device.
class Purpose {
  const Purpose({
    required this.id,
    required this.title,
    required this.why,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String why;
  final DateTime createdAt;

  Purpose copyWith({String? title, String? why}) {
    return Purpose(
      id: id,
      title: title ?? this.title,
      why: why ?? this.why,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'why': why,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Purpose.fromJson(Map<String, dynamic> json) {
    return Purpose(
      id: json['id'] as String,
      title: json['title'] as String,
      why: json['why'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

List<Purpose> samplePurposes({required DateTime now}) {
  return [
    Purpose(
      id: 'purpose-outside',
      title: 'Get outside this week',
      why: 'Leave the house with other people. Not a thread — a walk.',
      createdAt: now,
    ),
    Purpose(
      id: 'purpose-table',
      title: 'Feed people',
      why: 'A table, a time, dishes that actually arrive.',
      createdAt: now.subtract(const Duration(hours: 8)),
    ),
  ];
}
