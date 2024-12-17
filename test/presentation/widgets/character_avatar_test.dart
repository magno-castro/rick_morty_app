import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_app/presentation/widgets/character_avatar.dart';

void main() {
  group('CharacterAvatar =>', () {
    testWidgets('should display network image when valid URL is provided',
        (tester) async {
      const imageUrl = 'https://example.com/image.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CharacterAvatar(image: imageUrl),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(find.byType(Image), findsOneWidget);
      expect(image.fit, BoxFit.cover);
      expect(image.height, 250.0);
    });

    testWidgets('should display fallback icon when image fails to load',
        (tester) async {
      const invalidImageUrl = 'invalid_url';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CharacterAvatar(image: invalidImageUrl),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should apply custom border radius when provided',
        (tester) async {
      const imageUrl = 'https://example.com/image.jpg';
      final borderRadius = BorderRadius.circular(16);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterAvatar(
              image: imageUrl,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, borderRadius);
    });

    testWidgets('should use zero border radius when not provided',
        (tester) async {
      const imageUrl = 'https://example.com/image.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CharacterAvatar(image: imageUrl),
          ),
        ),
      );

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.zero);
    });
  });
}
