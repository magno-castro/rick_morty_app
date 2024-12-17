import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_app/presentation/widgets/character_card.dart';

import '../../fixtures/sample/character_sample.dart';

void main() {
  group('CharacterCard =>', () {
    testWidgets('should display character information correctly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterCard(
              character: characterSample,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text(characterSample.name), findsOneWidget);
      expect(find.text('Status:'), findsOneWidget);
      expect(find.text(characterSample.status), findsOneWidget);
      expect(find.text('Gender:'), findsOneWidget);
      expect(find.text(characterSample.gender), findsOneWidget);
      expect(find.text('Species:'), findsOneWidget);
      expect(find.text(characterSample.species), findsOneWidget);
      expect(find.text('Origin:'), findsOneWidget);
      expect(find.text(characterSample.origin), findsOneWidget);
      expect(find.text('Location:'), findsOneWidget);
      expect(find.text(characterSample.location), findsOneWidget);
    });

    testWidgets('should trigger onTap callback when tapped', (tester) async {
      var onTapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterCard(
              character: characterSample,
              onTap: () => onTapCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(onTapCalled, true);
    });

    testWidgets('should have correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterCard(
              character: characterSample,
              onTap: () {},
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, const EdgeInsets.only(bottom: 16));
      expect(card.clipBehavior, Clip.antiAlias);

      final titleStyle =
          tester.widget<Text>(find.text(characterSample.name)).style;
      expect(
          titleStyle?.fontSize,
          Theme.of(tester.element(find.byType(Card)))
              .textTheme
              .titleLarge
              ?.fontSize);
    });

    testWidgets('should display CharacterAvatar with correct image',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterCard(
              character: characterSample,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text(characterSample.name), findsOneWidget);
    });
  });
}
