import 'package:mobile/counter.dart';
import 'package:test/test.dart';

void main() {
  group('Test Login', () {
    test('First name is returned from login', () async {
      expect(Counter().value, 0);
    });

    test('value should be incremented', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });

    test('value should be decremented', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });
  });
}