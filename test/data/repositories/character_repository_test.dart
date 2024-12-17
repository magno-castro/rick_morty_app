import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_app/core/failures/connection_failure.dart';
import 'package:rick_morty_app/core/utils/network_info.dart';
import 'package:rick_morty_app/data/repositories/character_repository.dart';
import 'package:rick_morty_app/data/services/i_character_service.dart';
import '../../fixtures/sample/character_sample.dart';

class MockCharacterService extends Mock implements ICharacterService {}

class MockNetworkInfo extends Mock implements INetworkInfo {}

void main() {
  late CharacterRepository repository;
  late MockCharacterService mockService;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockService = MockCharacterService();
    mockNetworkInfo = MockNetworkInfo();
    repository = CharacterRepository(mockService, mockNetworkInfo);
  });

  group('CharacterRepository =>', () {
    group('get characters =>', () {
      test('should return characters list when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockService.characters(page: 1))
            .thenAnswer((_) async => [characterSample]);

        final result = await repository.characters(page: 1);

        expect(result, [characterSample]);
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockService.characters(page: 1)).called(1);
        verifyNoMoreInteractions(mockService);
        verifyNoMoreInteractions(mockNetworkInfo);
      });

      test('should throw NoConnectionFailure when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.characters(page: 1),
            throwsA(isA<NoConnectionFailure>()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockService);
      });
    });

    group('get character by id =>', () {
      test('should return character when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockService.characterById(id: 1))
            .thenAnswer((_) async => characterSample);

        final result = await repository.characterById(id: 1);

        expect(result, characterSample);
        verify(() => mockService.characterById(id: 1)).called(1);
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockService);
        verifyNoMoreInteractions(mockNetworkInfo);
      });

      test('should throw NoConnectionFailure when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.characterById(id: 1),
            throwsA(isA<NoConnectionFailure>()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockService);
      });
    });

    group('filter characters by name =>', () {
      test('should return filtered characters when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockService.filterCharactersByName(name: 'Rick', page: 1))
            .thenAnswer((_) async => [characterSample]);

        final result =
            await repository.filterCharactersByName(name: 'Rick', page: 1);

        expect(result, [characterSample]);
        verify(() => mockService.filterCharactersByName(name: 'Rick', page: 1))
            .called(1);
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockService);
        verifyNoMoreInteractions(mockNetworkInfo);
      });

      test('should throw NoConnectionFailure when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.filterCharactersByName(name: 'Rick', page: 1),
            throwsA(isA<NoConnectionFailure>()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockService);
      });
    });

    group('create character =>', () {
      test('should complete successfully when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockService.createCharacter(character: characterSample))
            .thenAnswer((_) async {});

        await expectLater(
          () => repository.createCharacter(character: characterSample),
          returnsNormally,
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockService.createCharacter(character: characterSample))
            .called(1);
        verifyNoMoreInteractions(mockService);
        verifyNoMoreInteractions(mockNetworkInfo);
      });

      test('should throw NoConnectionFailure when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.createCharacter(character: characterSample),
            throwsA(isA<NoConnectionFailure>()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockService);
      });
    });

    group('update character =>', () {
      test('should complete successfully when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockService.updateCharacter(character: characterSample))
            .thenAnswer((_) async {});

        await expectLater(
          () => repository.updateCharacter(character: characterSample),
          returnsNormally,
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockService.updateCharacter(character: characterSample))
            .called(1);
        verifyNoMoreInteractions(mockService);
        verifyNoMoreInteractions(mockNetworkInfo);
      });

      test('should throw NoConnectionFailure when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.updateCharacter(character: characterSample),
            throwsA(isA<NoConnectionFailure>()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockService);
      });
    });

    group('delete character =>', () {
      test('should complete successfully when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockService.deleteCharacter(id: 1)).thenAnswer((_) async {});

        await expectLater(
          () => repository.deleteCharacter(id: 1),
          returnsNormally,
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockService.deleteCharacter(id: 1)).called(1);
        verifyNoMoreInteractions(mockService);
        verifyNoMoreInteractions(mockNetworkInfo);
      });

      test('should throw NoConnectionFailure when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.deleteCharacter(id: 1),
            throwsA(isA<NoConnectionFailure>()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockService);
      });
    });
  });
}
