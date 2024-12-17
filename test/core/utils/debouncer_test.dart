import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_app/core/utils/debouncer.dart';

void main() {
  group('Debouncer =>', () {
    late Debouncer debouncer;

    setUp(() {
      debouncer = Debouncer(delay: const Duration(milliseconds: 100));
    });

    test('should execute action after delay', () async {
      int counter = 0;

      debouncer.run(() {
        counter++;
      });

      expect(counter, 0);

      await Future.delayed(const Duration(milliseconds: 150));

      expect(counter, 1);
    });

    test('should cancel previous timer when run is called multiple times',
        () async {
      int counter = 0;

      debouncer.run(() {
        counter++;
      });

      debouncer.run(() {
        counter++;
      });

      expect(counter, 0);

      await Future.delayed(const Duration(milliseconds: 150));

      expect(counter, 1);
    });

    test('should cancel timer when dispose is called', () async {
      int counter = 0;

      debouncer.run(() {
        counter++;
      });

      debouncer.dispose();

      await Future.delayed(const Duration(milliseconds: 150));

      expect(counter, 0);
    });

    test('should create debouncer with default delay of 1 second', () {
      final defaultDebouncer = Debouncer();
      expect(defaultDebouncer.delay, const Duration(seconds: 1));
    });
  });
}
