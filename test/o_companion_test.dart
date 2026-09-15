import 'package:darc_o/data/o_companion.dart';
import 'package:darc_o/models/intention.dart';
import 'package:darc_o/models/purpose.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const companion = StubOCompanion();

  final purpose = Purpose(
    id: 'p1',
    title: 'Get outside this week',
    why: 'Leave the house with other people.',
    createdAt: DateTime.utc(2026, 9, 14),
  );

  final intention = Intention(
    id: 't1',
    purposeId: 'p1',
    title: 'Evening walk',
    statement: 'Leave the house with two people.',
    whenLabel: 'Tonight after 18:00',
    people: const ['You', 'Rin'],
    status: IntentionStatus.brewing,
    createdAt: DateTime.utc(2026, 9, 14),
  );

  test('stub companion is explicitly a stub and names Grok as live chat', () {
    expect(companion.isStub, isTrue);
    expect(companion.id, 'stub');
    expect(companion.liveChatLabel, 'Grok');
  });

  test('assist labels every reply as stub and never says plan', () async {
    final reply = await companion.assist(
      intention: intention,
      purpose: purpose,
      fromName: 'Joshua',
      userNote: '',
    );
    expect(reply.stub, isTrue);
    expect(reply.source, 'stub');
    expect(reply.text.toLowerCase(), contains('stub'));
    expect(reply.text.toLowerCase(), contains('purpose'));
    expect(reply.text.toLowerCase(), isNot(contains('plan')));
    expect(reply.nextMoves, isNotEmpty);
  });

  test('invite note stays local and unlabeled as a live model', () async {
    final reply = await companion.assist(
      intention: intention,
      purpose: purpose,
      fromName: 'Joshua',
      userNote: 'Draft a short invite.',
    );
    expect(reply.stub, isTrue);
    expect(reply.text.toLowerCase(), isNot(contains('gpt')));
    expect(reply.text.toLowerCase(), isNot(contains('openai')));
    expect(reply.text.toLowerCase(), contains('stub'));
  });

  test('suggested prompts stay action-centred', () {
    final prompts = companion.suggestedPrompts(intention);
    expect(prompts, isNotEmpty);
    expect(prompts.join(' ').toLowerCase(), isNot(contains('atlas')));
    expect(prompts.join(' ').toLowerCase(), isNot(contains('plan')));
  });
}
