import '../models/intention.dart';
import '../models/companion_reply.dart';
import '../models/purpose.dart';

/// ō, the in-app coordinator.
///
/// Live chat, when wired, is **Grok**. Do not wire OpenAI / GPT.
/// A live model belongs behind this interface and must be user-initiated.
/// Do not commit API keys. The shipped implementation is [StubOCompanion].
abstract class OCompanion {
  String get id;
  bool get isStub;

  /// Intended live provider. Stub still reports this so the UI can be honest.
  String get liveChatLabel => 'Grok';

  List<String> suggestedPrompts(Intention intention);

  Future<CompanionReply> assist({
    required Intention intention,
    Purpose? purpose,
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
  String get liveChatLabel => 'Grok';

  @override
  List<String> suggestedPrompts(Intention intention) {
    final prompts = <String>[
      'Who still needs a yes?',
      'Propose a concrete time.',
    ];
    if (intention.people.length < 3) {
      prompts.add('Draft a short invite.');
    } else {
      prompts.add('What is the next physical step?');
    }
    return prompts;
  }

  @override
  Future<CompanionReply> assist({
    required Intention intention,
    Purpose? purpose,
    required String fromName,
    required String userNote,
  }) async {
    final note = userNote.trim();
    final names = intention.people.isEmpty
        ? 'just $fromName for now'
        : intention.people.join(', ');
    final when = intention.whenLabel ?? 'a time you have not locked';
    final purposeTitle = purpose?.title ?? 'this purpose';

    final focused = note.isEmpty
        ? _open(intention, purposeTitle, fromName, names, when)
        : _fromNote(intention, purposeTitle, fromName, names, when, note);

    return CompanionReply(
      text: focused,
      nextMoves: _moves(intention, note),
      source: id,
      stub: true,
    );
  }

  String _open(
    Intention intention,
    String purposeTitle,
    String fromName,
    String names,
    String when,
  ) {
    return 'Stub · $fromName, “${intention.title}” is ${intention.status.label.toLowerCase()}. '
        'Purpose: $purposeTitle. People on it: $names. Window: $when. '
        'I will not invent a live schedule — pick a next move and I will draft around it.';
  }

  String _fromNote(
    Intention intention,
    String purposeTitle,
    String fromName,
    String names,
    String when,
    String note,
  ) {
    final lower = note.toLowerCase();
    if (lower.contains('invite') || lower.contains('yes')) {
      return 'Stub · Invite draft for “${intention.title}” under $purposeTitle: '
          '“$fromName here — we are doing this, not chatting about it. '
          'Window is $when. Who is in?” Send it to $names. '
          'This text is generated locally. No model ran.';
    }
    if (lower.contains('time') || lower.contains('when')) {
      return 'Stub · Time lock for “${intention.title}”: treat “$when” as the offer. '
          'Ask everyone to answer with one number — a clock time — not “maybe”. '
          'Local stub only.';
    }
    return 'Stub · Heard: “$note”. For “${intention.title}” with $names, '
        'turn that into one verb you can do in the next hour. '
        'ō (stub) will not call anyone or send messages.';
  }

  List<String> _moves(Intention intention, String note) {
    final moves = <String>[
      'Name the first person you will actually ask.',
      if (intention.whenLabel == null) 'Put a clock time on the intention.',
      if (intention.status == IntentionStatus.brewing)
        'Commit the intention once someone else is in.',
      if (note.toLowerCase().contains('invite'))
        'Copy the draft and send it yourself — ō does not send yet.',
    ];
    return moves.take(3).toList();
  }
}
