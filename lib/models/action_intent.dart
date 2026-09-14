enum ActionStatus { brewing, inMotion, done }

extension ActionStatusLabel on ActionStatus {
  String get label => switch (this) {
    ActionStatus.brewing => 'Brewing',
    ActionStatus.inMotion => 'In motion',
    ActionStatus.done => 'Done',
  };

  ActionStatus get next => switch (this) {
    ActionStatus.brewing => ActionStatus.inMotion,
    ActionStatus.inMotion => ActionStatus.done,
    ActionStatus.done => ActionStatus.brewing,
  };
}

/// Something a person wants to do with others.
class ActionIntent {
  const ActionIntent({
    required this.id,
    required this.title,
    required this.intent,
    required this.people,
    required this.status,
    required this.createdAt,
    this.whenLabel,
  });

  final String id;
  final String title;
  final String intent;
  final String? whenLabel;
  final List<String> people;
  final ActionStatus status;
  final DateTime createdAt;

  ActionIntent copyWith({
    String? title,
    String? intent,
    String? whenLabel,
    List<String>? people,
    ActionStatus? status,
    bool clearWhen = false,
  }) {
    return ActionIntent(
      id: id,
      title: title ?? this.title,
      intent: intent ?? this.intent,
      whenLabel: clearWhen ? null : (whenLabel ?? this.whenLabel),
      people: people ?? this.people,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'intent': intent,
    'whenLabel': whenLabel,
    'people': people,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ActionIntent.fromJson(Map<String, dynamic> json) {
    return ActionIntent(
      id: json['id'] as String,
      title: json['title'] as String,
      intent: json['intent'] as String,
      whenLabel: json['whenLabel'] as String?,
      people: (json['people'] as List<dynamic>).cast<String>(),
      status: ActionStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

List<ActionIntent> sampleActions({required DateTime now}) {
  return [
    ActionIntent(
      id: 'sample-walk',
      title: 'Evening walk',
      intent:
          'Find two people free after six and actually leave the house. Not a chat thread — a walk.',
      whenLabel: 'Tonight after 18:00',
      people: const ['You', 'Sam'],
      status: ActionStatus.brewing,
      createdAt: now,
    ),
    ActionIntent(
      id: 'sample-potluck',
      title: 'Saturday potluck',
      intent:
          'One dish each. Lock a kitchen and a time. ō helps chase the last two yeses.',
      whenLabel: 'Saturday, late afternoon',
      people: const ['You', 'Rin', 'Ade'],
      status: ActionStatus.inMotion,
      createdAt: now.subtract(const Duration(hours: 6)),
    ),
  ];
}
