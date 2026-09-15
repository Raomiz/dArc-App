import 'package:darc_o/data/presence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder cast is recognized', () {
    expect(isPlaceholderHuman('Rin'), isTrue);
    expect(isPlaceholderHuman(' rin '), isTrue);
    expect(isPlaceholderHuman('Ade'), isTrue);
    expect(isPlaceholderHuman('You'), isTrue);
    expect(isPlaceholderHuman(''), isTrue);
    expect(isPlaceholderHuman('Joshua'), isFalse);
    expect(isPlaceholderHuman('Maya'), isFalse);
    expect(isPlaceholderHuman('Sam'), isFalse);
  });

  test('house presence is empty without a session or real names', () {
    expect(
      housePresence(people: const ['Rin', 'Ade', 'You'], sessionName: null),
      isEmpty,
    );
  });

  test('session name is the only human unless someone real is typed', () {
    expect(
      housePresence(
        people: const ['You', 'Rin', 'Ade'],
        sessionName: 'Joshua',
      ),
      ['Joshua'],
    );
    expect(
      housePresence(
        people: const ['Rin', 'Maya', 'Joshua'],
        sessionName: 'Joshua',
      ),
      ['Joshua', 'Maya'],
    );
  });
}
