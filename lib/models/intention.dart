/// A committed action with other people.
///
/// User-facing word is **Intention**. Never call this a plan.
enum IntentionStatus { brewing, committed, done }

extension IntentionStatusLabel on IntentionStatus {
  String get label => switch (this) {
    IntentionStatus.brewing => 'Brewing',
    IntentionStatus.committed => 'Committed',
    IntentionStatus.done => 'Done',
  };

  IntentionStatus get next => switch (this) {
    IntentionStatus.brewing => IntentionStatus.committed,
    IntentionStatus.committed => IntentionStatus.done,
    IntentionStatus.done => IntentionStatus.brewing,
  };
}

class Intention {
  const Intention({
    required this.id,
    required this.purposeId,
    required this.title,
    required this.statement,
    required this.people,
    required this.status,
    required this.createdAt,
    this.whenLabel,
  });

  final String id;
  final String purposeId;
  final String title;
  final String statement;
  final String? whenLabel;
  final List<String> people;
  final IntentionStatus status;
  final DateTime createdAt;

  Intention copyWith({
    String? title,
    String? statement,
    String? whenLabel,
    List<String>? people,
    IntentionStatus? status,
    bool clearWhen = false,
  }) {
    return Intention(
      id: id,
      purposeId: purposeId,
      title: title ?? this.title,
      statement: statement ?? this.statement,
      whenLabel: clearWhen ? null : (whenLabel ?? this.whenLabel),
      people: people ?? this.people,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'purposeId': purposeId,
    'title': title,
    'statement': statement,
    'whenLabel': whenLabel,
    'people': people,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Intention.fromJson(Map<String, dynamic> json) {
    return Intention(
      id: json['id'] as String,
      purposeId: json['purposeId'] as String,
      title: json['title'] as String,
      statement: json['statement'] as String,
      whenLabel: json['whenLabel'] as String?,
      people: (json['people'] as List<dynamic>).cast<String>(),
      status: IntentionStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// Sample intentions may exist as teaching shapes.
/// They never invent a cast — only the local session name, or empty.
List<Intention> sampleIntentions({
  required DateTime now,
  String? sessionName,
}) {
  final people = sessionName == null || sessionName.trim().isEmpty
      ? const <String>[]
      : [sessionName.trim()];
  return [
    Intention(
      id: 'sample-walk',
      purposeId: 'purpose-outside',
      title: 'Evening walk',
      statement:
          'Leave the house. Not a chat thread — a walk.',
      whenLabel: 'Tonight after 18:00',
      people: people,
      status: IntentionStatus.brewing,
      createdAt: now,
    ),
    Intention(
      id: 'sample-potluck',
      purposeId: 'purpose-table',
      title: 'Saturday potluck',
      statement:
          'One dish. Lock a kitchen and a time.',
      whenLabel: 'Saturday, late afternoon',
      people: people,
      status: IntentionStatus.committed,
      createdAt: now.subtract(const Duration(hours: 6)),
    ),
  ];
}
