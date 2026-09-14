import '../models/action_intent.dart';
import '../models/companion_reply.dart';

/// ō, the in-app coordinator.
///
/// A live model belongs behind this interface and must be user-initiated.
/// Do not commit API keys. The shipped implementation is [StubOCompanion].
abstract class OCompanion {
  String get id;
  bool get isStub;

  List<String> suggestedPrompts(ActionIntent action);

  Future<CompanionReply> assist({
    required ActionIntent action,
    required String fromName,
    required String userNote,
  });
}

/// Deterministic mock. Replies are labeled stub so nobody mistakes them for a model.
class StubOCompanion implements OCompanion {
  const StubOCompanion();

  @override
  String get id => 'stub';

  @override
  bool get isStub => true;

  @override
  List<String> suggestedPrompts(ActionIntent action) {
    final prompts = <String>[
      'Who still needs a yes?',
      'Propose a concrete time.',
    ];
    if (action.people.length < 3) {
      prompts.add('Draft a short invite.');
    } else {
      prompts.add('What is the next physical step?');
    }
    return prompts;
  }

  @override
  Future<CompanionReply> assist({
    required ActionIntent action,
    required String fromName,
    required String userNote,
  }) async {
    final note = userNote.trim();
    final names = action.people.isEmpty
        ? 'just $fromName for now'
        : action.people.join(', ');
    final when = action.whenLabel ?? 'a time you have not locked';

    final focused = note.isEmpty
        ? _open(action, fromName, names, when)
        : _fromNote(action, fromName, names, when, note);

    return CompanionReply(
      text: focused,
      nextMoves: _moves(action, note),
      source: id,
      stub: true,
    );
  }

  String _open(
    ActionIntent action,
    String fromName,
    String names,
    String when,
  ) {
    return 'Stub · $fromName, “${action.title}” is ${action.status.label.toLowerCase()}. '
        'People on it: $names. Window: $when. '
        'I will not invent a live plan — pick a next move and I will draft around it.';
  }

  String _fromNote(
    ActionIntent action,
    String fromName,
    String names,
    String when,
    String note,
  ) {
    final lower = note.toLowerCase();
    if (lower.contains('invite') || lower.contains('yes')) {
      return 'Stub · Invite draft for “${action.title}”: '
          '“$fromName here — we are doing this, not chatting about it. '
          'Window is $when. Who is in?” Send it to $names. '
          'This text is generated locally. No model ran.';
    }
    if (lower.contains('time') || lower.contains('when')) {
      return 'Stub · Time lock for “${action.title}”: treat “$when” as the offer. '
          'Ask everyone to answer with one number — a clock time — not “maybe”. '
          'Local stub only.';
    }
    return 'Stub · Heard: “$note”. For “${action.title}” with $names, '
        'turn that into one verb you can do in the next hour. '
        'ō (stub) will not call anyone or send messages.';
  }

  List<String> _moves(ActionIntent action, String note) {
    final moves = <String>[
      'Name the first person you will actually ask.',
      if (action.whenLabel == null) 'Put a clock time on the action.',
      if (action.status == ActionStatus.brewing) 'Mark it in motion once someone else is in.',
      if (note.toLowerCase().contains('invite'))
        'Copy the draft and send it yourself — ō does not send yet.',
    ];
    return moves.take(3).toList();
  }
}
