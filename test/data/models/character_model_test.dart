import 'package:flutter_test/flutter_test.dart';
import 'package:rick_morty_app/data/models/character_model.dart';

import '../../fixtures/json/character_json.dart';
import '../../fixtures/sample/character_sample.dart';

void main() {
  group('CharacterModel =>', () {
    test('should convert from JSON correctly', () {
      final result = CharacterModel.fromJson(characterJson);
      expect(result, equals(characterSample));
    });

    test('should convert to JSON correctly', () {
      final result = characterSample.toJson();
      expect(result, equals(characterJson));
    });
  });
}
