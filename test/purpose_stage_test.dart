import 'package:darc_o/models/intention.dart';
import 'package:darc_o/widgets/purpose_stage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('peopleOnPurpose keeps real names and drops repeats', () {
    final now = DateTime.utc(2026, 9, 15);
    final items = [
      Intention(
        id: 'a',
        purposeId: 'p',
        title: 'Evening walk',
        statement: 'Leave the house.',
        people: const ['Joshua', 'Maya'],
        status: IntentionStatus.brewing,
        createdAt: now,
      ),
      Intention(
        id: 'b',
        purposeId: 'p',
        title: 'Saturday potluck',
        statement: 'One dish.',
        people: const ['joshua', 'Maya'],
        status: IntentionStatus.committed,
        createdAt: now,
      ),
    ];
    expect(peopleOnPurpose(items), ['Joshua', 'Maya']);
    expect(peopleOnPurpose(const []), isEmpty);
  });

  test('manner labels stay Purpose language — never plan', () {
    final labels = PurposeManner.values.map((m) => m.label).join(' ');
    expect(labels.toLowerCase(), isNot(contains('plan')));
    expect(labels, contains('Intentions'));
    expect(labels, contains('Brewing'));
    expect(labels, contains('People'));
    expect(labels, contains('Evidence'));
  });
}
