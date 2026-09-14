class LocalSession {
  const LocalSession({
    required this.id,
    required this.displayName,
    required this.startedAt,
  });

  final String id;
  final String displayName;
  final DateTime startedAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'displayName': displayName,
    'startedAt': startedAt.toIso8601String(),
  };

  factory LocalSession.fromJson(Map<String, dynamic> json) {
    return LocalSession(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
    );
  }
}
