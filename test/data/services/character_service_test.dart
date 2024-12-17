import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_app/core/failures/api_failure.dart';
import 'package:rick_morty_app/data/services/character_service.dart';

import '../../fixtures/json/character_json.dart';
import '../../fixtures/sample/character_sample.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late CharacterService characterService;
  late MockHttpClient mockHttpClient;
  const testApiUrl = 'https://api.example.com';

  setUp(() {
    mockHttpClient = MockHttpClient();
    characterService = CharacterService(mockHttpClient, testApiUrl);
    registerFallbackValue(Uri.parse(''));
  });

  group('CharacterService => ', () {
    group('get characters =>', () {
      test('should return list of characters when status code is 200',
          () async {
        when(() => mockHttpClient.get(Uri.parse('$testApiUrl/characters')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode({
              'results': [characterJson]
            }),
            200,
          ),
        );

        final result = await characterService.characters();

        expect(result, [characterSample]);
        verify(() => mockHttpClient.get(Uri.parse('$testApiUrl/characters')))
            .called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });

      test('should throw ApiFailure when status code is not 200', () async {
        when(() => mockHttpClient.get(Uri.parse('$testApiUrl/characters')))
            .thenAnswer(
          (_) async => http.Response(json.encode({'message': 'error'}), 404),
        );

        expect(
          () => characterService.characters(),
          throwsA(isA<ApiFailure>()),
        );
        verify(() => mockHttpClient.get(Uri.parse('$testApiUrl/characters')))
            .called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });
    });

    group('get character by id => ', () {
      test('should return character when status code is 200', () async {
        when(() => mockHttpClient.get(Uri.parse('$testApiUrl/characters/1')))
            .thenAnswer(
          (_) async => http.Response(
            json.encode(characterJson),
            200,
          ),
        );

        final result = await characterService.characterById(id: 1);

        expect(result, characterSample);
        verify(() => mockHttpClient.get(Uri.parse('$testApiUrl/characters/1')))
            .called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });

      test('should throw ApiFailure when status code is not 200', () async {
        when(() => mockHttpClient.get(Uri.parse('$testApiUrl/characters/1')))
            .thenAnswer(
          (_) async => http.Response(json.encode({'message': 'error'}), 404),
        );

        expect(
          () => characterService.characterById(id: 1),
          throwsA(isA<ApiFailure>()),
        );
        verify(() => mockHttpClient.get(Uri.parse('$testApiUrl/characters/1')))
            .called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });
    });

    group('filter characters by name =>', () {
      test('should return filtered characters when status code is 200',
          () async {
        when(() => mockHttpClient.get(
              Uri.parse('$testApiUrl/characters').replace(
                queryParameters: {'name': 'Rick'},
              ),
            )).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'results': [characterJson]
            }),
            200,
          ),
        );

        final result =
            await characterService.filterCharactersByName(name: 'Rick');

        expect(result, [characterSample]);
        verify(() =>
            mockHttpClient.get(Uri.parse('$testApiUrl/characters').replace(
              queryParameters: {'name': 'Rick'},
            ))).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });

      test('should throw ApiFailure when status code is not 200', () async {
        when(() => mockHttpClient.get(
              Uri.parse('$testApiUrl/characters').replace(
                queryParameters: {'name': 'Rick'},
              ),
            )).thenAnswer(
          (_) async => http.Response(json.encode({'message': 'error'}), 404),
        );

        expect(
          () => characterService.filterCharactersByName(name: 'Rick'),
          throwsA(isA<ApiFailure>()),
        );
        verify(() =>
            mockHttpClient.get(Uri.parse('$testApiUrl/characters').replace(
              queryParameters: {'name': 'Rick'},
            ))).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });
    });

    group('create character =>', () {
      test('should complete successfully when status code is 201', () async {
        when(() => mockHttpClient.post(
              Uri.parse('$testApiUrl/characters/create'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(characterJson),
            )).thenAnswer((_) async => http.Response('{}', 201));

        await expectLater(
          () => characterService.createCharacter(character: characterSample),
          returnsNormally,
        );
        verify(() => mockHttpClient.post(
              Uri.parse('$testApiUrl/characters/create'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(characterJson),
            )).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });

      test('should throw ApiFailure when status code is not 201', () async {
        when(() => mockHttpClient.post(
                  Uri.parse('$testApiUrl/characters/create'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode(characterJson),
                ))
            .thenAnswer((_) async =>
                http.Response(json.encode({'message': 'error'}), 400));

        expect(
          () => characterService.createCharacter(character: characterSample),
          throwsA(isA<ApiFailure>()),
        );

        verify(() => mockHttpClient.post(
              Uri.parse('$testApiUrl/characters/create'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(characterJson),
            )).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });
    });

    group('update character =>', () {
      test('should complete successfully when status code is below 400',
          () async {
        when(() => mockHttpClient.put(
              Uri.parse('$testApiUrl/characters/1'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(characterJson),
            )).thenAnswer((_) async => http.Response('{}', 200));

        await expectLater(
          characterService.updateCharacter(character: characterSample),
          completes,
        );

        verify(() => mockHttpClient.put(
              Uri.parse('$testApiUrl/characters/1'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(characterJson),
            )).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });

      test('should throw ApiFailure when status code is 400 or above',
          () async {
        when(() => mockHttpClient.put(
                  Uri.parse('$testApiUrl/characters/1'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode(characterJson),
                ))
            .thenAnswer((_) async =>
                http.Response(json.encode({'message': 'error'}), 400));

        expect(
          () => characterService.updateCharacter(character: characterSample),
          throwsA(isA<ApiFailure>()),
        );

        verify(() => mockHttpClient.put(
              Uri.parse('$testApiUrl/characters/1'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(characterJson),
            )).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });
    });

    group('delete character =>', () {
      test('should complete successfully when status code is 200', () async {
        when(() => mockHttpClient.delete(Uri.parse('$testApiUrl/characters/1')))
            .thenAnswer((_) async => http.Response('{}', 200));

        await expectLater(
          characterService.deleteCharacter(id: 1),
          completes,
        );
        verify(() =>
                mockHttpClient.delete(Uri.parse('$testApiUrl/characters/1')))
            .called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });

      test('should throw ApiFailure when status code is not 200', () async {
        when(() => mockHttpClient.delete(Uri.parse('$testApiUrl/characters/1')))
            .thenAnswer((_) async =>
                http.Response(json.encode({'message': 'error'}), 404));

        expect(
          () => characterService.deleteCharacter(id: 1),
          throwsA(isA<ApiFailure>()),
        );

        verify(() =>
                mockHttpClient.delete(Uri.parse('$testApiUrl/characters/1')))
            .called(1);
        verifyNoMoreInteractions(mockHttpClient);
      });
    });
  });
}
