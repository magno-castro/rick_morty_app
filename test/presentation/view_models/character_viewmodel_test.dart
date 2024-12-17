import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_app/core/failures/api_failure.dart';
import 'package:rick_morty_app/core/failures/connection_failure.dart';
import 'package:rick_morty_app/data/repositories/i_character_repository.dart';
import 'package:rick_morty_app/presentation/view_models/character_viewmodel.dart';

import '../../fixtures/sample/character_sample.dart';

class MockCharacterRepository extends Mock implements ICharacterRepository {}

void main() {
  late CharacterViewModel viewModel;
  late MockCharacterRepository mockRepository;

  setUp(() {
    mockRepository = MockCharacterRepository();
    viewModel = CharacterViewModel(mockRepository);
  });

  group('CharacterViewModel =>', () {
    group('load characters =>', () {
      test('should update state correctly when successful', () async {
        when(() => mockRepository.characters(page: 1))
            .thenAnswer((_) async => [characterSample]);

        await viewModel.loadCharacters();

        expect(viewModel.characters, [characterSample]);
        expect(viewModel.isListLoading, false);
        expect(viewModel.listError, null);
        expect(viewModel.hasMorePage, true);
        expect(viewModel.page, 2);
        verify(() => mockRepository.characters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle empty response correctly', () async {
        when(() => mockRepository.characters(page: 1))
            .thenAnswer((_) async => []);

        await viewModel.loadCharacters();

        expect(viewModel.characters, isEmpty);
        expect(viewModel.hasMorePage, false);
        expect(viewModel.isListLoading, false);
        expect(viewModel.listError, null);
        verify(() => mockRepository.characters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should paginate characters', () async {
        when(() => mockRepository.characters(page: 1))
            .thenAnswer((_) async => [characterSample]);
        when(() => mockRepository.characters(page: 2))
            .thenAnswer((_) async => [characterSample]);
        when(() => mockRepository.characters(page: 3))
            .thenAnswer((_) async => []);

        await viewModel.loadCharacters();
        await viewModel.loadCharacters(page: 2);
        await viewModel.loadCharacters(page: 3);

        expect(viewModel.characters, [characterSample, characterSample]);
        expect(viewModel.hasMorePage, false);
        verify(() => mockRepository.characters(page: 1)).called(1);
        verify(() => mockRepository.characters(page: 2)).called(1);
        verify(() => mockRepository.characters(page: 3)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle ApiFailure correctly', () async {
        when(() => mockRepository.characters(page: 1)).thenThrow(
            const ApiFailure(
                statusCode: 404,
                message: 'Not Found',
                serverResponseBody: 'Not Found'));

        await viewModel.loadCharacters();

        expect(viewModel.listError, 'Not Found');
        expect(viewModel.isListLoading, false);
        verify(() => mockRepository.characters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle NoConnectionFailure correctly', () async {
        when(() => mockRepository.characters(page: 1))
            .thenThrow(const NoConnectionFailure());

        await viewModel.loadCharacters();

        expect(viewModel.listError, 'No connection');
        expect(viewModel.isListLoading, false);
        verify(() => mockRepository.characters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('load character by id =>', () {
      test('should update state correctly when successful', () async {
        when(() => mockRepository.characterById(id: 1))
            .thenAnswer((_) async => characterSample);

        await viewModel.loadCharacterById(id: 1);

        expect(viewModel.selectedCharacter, characterSample);
        expect(viewModel.editingStatus, EditingStatus.idle);
        expect(viewModel.editingError, null);
        verify(() => mockRepository.characterById(id: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle ApiFailure correctly', () async {
        when(() => mockRepository.characterById(id: 1)).thenThrow(
            const ApiFailure(
                statusCode: 404,
                message: 'Not Found',
                serverResponseBody: 'Not Found'));

        await viewModel.loadCharacterById(id: 1);

        expect(viewModel.editingError, 'Not Found');
        expect(viewModel.editingStatus, EditingStatus.idle);
        verify(() => mockRepository.characterById(id: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle NoConnectionFailure correctly', () async {
        when(() => mockRepository.characterById(id: 1))
            .thenThrow(const NoConnectionFailure());

        await viewModel.loadCharacterById(id: 1);

        expect(viewModel.editingError, 'No connection');
        expect(viewModel.editingStatus, EditingStatus.idle);
        verify(() => mockRepository.characterById(id: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('filter characters by name =>', () {
      test('should update state correctly when successful', () async {
        when(() => mockRepository.filterCharactersByName(name: 'Rick', page: 1))
            .thenAnswer((_) async => [characterSample]);

        await viewModel.filterCharacters(name: 'Rick');

        expect(viewModel.characters, [characterSample]);
        expect(viewModel.isListLoading, false);
        expect(viewModel.listError, null);
        verify(() =>
                mockRepository.filterCharactersByName(name: 'Rick', page: 1))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should paginate characters', () async {
        when(() => mockRepository.filterCharactersByName(name: 'Rick', page: 1))
            .thenAnswer((_) async => [characterSample]);
        when(() => mockRepository.filterCharactersByName(name: 'Rick', page: 2))
            .thenAnswer((_) async => [characterSample]);
        when(() => mockRepository.filterCharactersByName(name: 'Rick', page: 3))
            .thenAnswer((_) async => []);

        await viewModel.filterCharacters(name: 'Rick');
        await viewModel.filterCharacters(name: 'Rick', page: 2);
        await viewModel.filterCharacters(name: 'Rick', page: 3);

        expect(viewModel.characters, [characterSample, characterSample]);
        expect(viewModel.hasMorePage, false);
        verify(() =>
                mockRepository.filterCharactersByName(name: 'Rick', page: 1))
            .called(1);
        verify(() =>
                mockRepository.filterCharactersByName(name: 'Rick', page: 2))
            .called(1);
        verify(() =>
                mockRepository.filterCharactersByName(name: 'Rick', page: 3))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle ApiFailure correctly', () async {
        when(() => mockRepository.filterCharactersByName(name: 'Rick', page: 1))
            .thenThrow(const ApiFailure(
                statusCode: 404,
                message: 'Not Found',
                serverResponseBody: 'Not Found'));

        await viewModel.filterCharacters(name: 'Rick');

        expect(viewModel.listError, 'Not Found');
        expect(viewModel.isListLoading, false);
        verify(() =>
                mockRepository.filterCharactersByName(name: 'Rick', page: 1))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle NoConnectionFailure correctly', () async {
        when(() => mockRepository.filterCharactersByName(name: 'Rick', page: 1))
            .thenThrow(const NoConnectionFailure());

        await viewModel.filterCharacters(name: 'Rick');

        expect(viewModel.listError, 'No connection');
        expect(viewModel.isListLoading, false);
        verify(() =>
                mockRepository.filterCharactersByName(name: 'Rick', page: 1))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('create character =>', () {
      test('should update state correctly when successful', () async {
        when(() => mockRepository.createCharacter(character: characterSample))
            .thenAnswer((_) async {});
        when(() => mockRepository.characters(page: 1))
            .thenAnswer((_) async => [characterSample]);

        await viewModel.createCharacter(character: characterSample);

        expect(viewModel.editingStatus, EditingStatus.completed);
        expect(viewModel.editingError, null);
        verify(() => mockRepository.createCharacter(character: characterSample))
            .called(1);
        verify(() => mockRepository.characters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle ApiFailure correctly', () async {
        when(() => mockRepository.createCharacter(character: characterSample))
            .thenThrow(const ApiFailure(
                statusCode: 404,
                message: 'Not Found',
                serverResponseBody: 'Not Found'));

        await viewModel.createCharacter(character: characterSample);
        expect(viewModel.editingStatus, EditingStatus.idle);
        expect(viewModel.editingError, 'Not Found');
        verify(() => mockRepository.createCharacter(character: characterSample))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle NoConnectionFailure correctly', () async {
        when(() => mockRepository.createCharacter(character: characterSample))
            .thenThrow(const NoConnectionFailure());

        await viewModel.createCharacter(character: characterSample);

        expect(viewModel.editingStatus, EditingStatus.idle);
        expect(viewModel.editingError, 'No connection');
        verify(() => mockRepository.createCharacter(character: characterSample))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('update character =>', () {
      test('should update state correctly when successful', () async {
        when(() => mockRepository.updateCharacter(character: characterSample))
            .thenAnswer((_) async {});
        when(() => mockRepository.characters(page: 1))
            .thenAnswer((_) async => [characterSample]);

        await viewModel.updateCharacter(character: characterSample);

        expect(viewModel.editingStatus, EditingStatus.completed);
        expect(viewModel.editingError, null);
        verify(() => mockRepository.updateCharacter(character: characterSample))
            .called(1);
        verify(() => mockRepository.characters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle ApiFailure correctly', () async {
        when(() => mockRepository.updateCharacter(character: characterSample))
            .thenThrow(const ApiFailure(
                statusCode: 404,
                message: 'Not Found',
                serverResponseBody: 'Not Found'));

        await viewModel.updateCharacter(character: characterSample);

        expect(viewModel.editingStatus, EditingStatus.idle);
        expect(viewModel.editingError, 'Not Found');
        verify(() => mockRepository.updateCharacter(character: characterSample))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle NoConnectionFailure correctly', () async {
        when(() => mockRepository.updateCharacter(character: characterSample))
            .thenThrow(const NoConnectionFailure());

        await viewModel.updateCharacter(character: characterSample);

        expect(viewModel.editingStatus, EditingStatus.idle);
        expect(viewModel.editingError, 'No connection');
        verify(() => mockRepository.updateCharacter(character: characterSample))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('delete character =>', () {
      test('should update state correctly when successful', () async {
        when(() => mockRepository.deleteCharacter(id: 1))
            .thenAnswer((_) async {});
        when(() => mockRepository.characters(page: 1))
            .thenAnswer((_) async => [characterSample]);

        await viewModel.deleteCharacter(id: 1);

        expect(viewModel.editingStatus, EditingStatus.completed);
        expect(viewModel.editingError, null);
        verify(() => mockRepository.deleteCharacter(id: 1)).called(1);
        verify(() => mockRepository.characters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle ApiFailure correctly', () async {
        when(() => mockRepository.deleteCharacter(id: 1)).thenThrow(
            const ApiFailure(
                statusCode: 404,
                message: 'Not Found',
                serverResponseBody: 'Not Found'));

        await viewModel.deleteCharacter(id: 1);

        expect(viewModel.editingStatus, EditingStatus.idle);
        expect(viewModel.editingError, 'Not Found');
        verify(() => mockRepository.deleteCharacter(id: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle NoConnectionFailure correctly', () async {
        when(() => mockRepository.deleteCharacter(id: 1))
            .thenThrow(const NoConnectionFailure());

        await viewModel.deleteCharacter(id: 1);

        expect(viewModel.editingStatus, EditingStatus.idle);
        expect(viewModel.editingError, 'No connection');
        verify(() => mockRepository.deleteCharacter(id: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('clear character detail =>', () {
      test('should clear selected character and reset editing status', () {
        viewModel.clearCharacterDetail();

        expect(viewModel.selectedCharacter, null);
        expect(viewModel.editingStatus, EditingStatus.idle);
        expect(viewModel.editingError, null);
        verifyZeroInteractions(mockRepository);
      });
    });

    group('clear list error =>', () {
      test('should clear list error', () {
        viewModel.clearListError();

        expect(viewModel.listError, null);
        verifyZeroInteractions(mockRepository);
      });
    });

    group('clear editing error =>', () {
      test('should clear editing error', () {
        viewModel.clearEditingError();

        expect(viewModel.editingError, null);
        verifyZeroInteractions(mockRepository);
      });
    });
  });
}
