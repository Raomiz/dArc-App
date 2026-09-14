import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/models/action_intent.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const companion = StubOCompanion();

  final action = ActionIntent(
    id: 't1',
    title: 'Evening walk',
    intent: 'Leave the house with two people.',
    whenLabel: 'Tonight after 18:00',
    people: const ['You', 'Sam'],
    status: ActionStatus.brewing,
    createdAt: DateTime.utc(2026, 9, 14),
  );

  test('stub companion is explicitly a stub', () {
    expect(companion.isStub, isTrue);
    expect(companion.id, 'stub');
  });

  test('assist labels every reply as stub', () async {
    final reply = await companion.assist(
      action: action,
      fromName: 'Joshua',
      userNote: '',
    );
    expect(reply.stub, isTrue);
    expect(reply.source, 'stub');
    expect(reply.text.toLowerCase(), contains('stub'));
    expect(reply.nextMoves, isNotEmpty);
  });

  test('invite note stays local and unlabeled as a live model', () async {
    final reply = await companion.assist(
      action: action,
      fromName: 'Joshua',
      userNote: 'Draft a short invite.',
    );
    expect(reply.stub, isTrue);
    expect(reply.text, isNot(contains('gpt')));
    expect(reply.text.toLowerCase(), contains('stub'));
  });

  test('suggested prompts stay action-centred', () {
    final prompts = companion.suggestedPrompts(action);
    expect(prompts, isNotEmpty);
    expect(prompts.join(' ').toLowerCase(), isNot(contains('atlas')));
  });
}
