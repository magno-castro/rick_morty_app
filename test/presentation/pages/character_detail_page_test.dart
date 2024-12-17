import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty_app/presentation/pages/character_detail_page.dart';
import 'package:rick_morty_app/presentation/view_models/character_viewmodel.dart';
import '../../fixtures/sample/character_sample.dart';

class MockCharacterViewModel extends Mock implements CharacterViewModel {}

void main() {
  late MockCharacterViewModel mockViewModel;

  Widget makeTestableWidget({int? characterId}) {
    return MaterialApp(
      home: ChangeNotifierProvider<CharacterViewModel>.value(
        value: mockViewModel,
        child: CharacterDetailPage(characterId: characterId),
      ),
    );
  }

  setUp(() {
    mockViewModel = MockCharacterViewModel();
  });

  group('CharacterDetailPage =>', () {
    testWidgets('should display loading indicator when loading',
        (tester) async {
      when(() => mockViewModel.editingStatus).thenReturn(EditingStatus.loading);
      when(() => mockViewModel.loadCharacterById(id: 1))
          .thenAnswer((_) async {});
      when(() => mockViewModel.addListener(any())).thenReturn(null);
      when(() => mockViewModel.removeListener(any())).thenReturn(null);

      await tester.pumpWidget(makeTestableWidget(characterId: 1));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(() => mockViewModel.editingStatus).called(1);
      verify(() => mockViewModel.loadCharacterById(id: 1)).called(1);
    });

    testWidgets('should display form with empty fields in create mode',
        (tester) async {
      when(() => mockViewModel.editingStatus).thenReturn(EditingStatus.idle);
      when(() => mockViewModel.selectedCharacter).thenReturn(null);
      when(() => mockViewModel.addListener(any())).thenReturn(null);
      when(() => mockViewModel.removeListener(any())).thenReturn(null);

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(find.text('Create Character'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(8));
      verify(() => mockViewModel.editingStatus).called(1);
    });

    testWidgets('should display form with character data in edit mode',
        (tester) async {
      when(() => mockViewModel.editingStatus).thenReturn(EditingStatus.idle);
      when(() => mockViewModel.selectedCharacter).thenReturn(characterSample);
      when(() => mockViewModel.loadCharacterById(id: 1))
          .thenAnswer((_) async {});
      when(() => mockViewModel.addListener(any())).thenReturn(null);
      when(() => mockViewModel.removeListener(any())).thenReturn(null);

      await tester.pumpWidget(makeTestableWidget(characterId: 1));
      await tester.pump();

      expect(find.text('Edit Character'), findsOneWidget);
      expect(find.text(characterSample.name), findsOneWidget);
      verify(() => mockViewModel.editingStatus).called(1);
      verify(() => mockViewModel.loadCharacterById(id: 1)).called(1);
    });

    testWidgets('should create character when form is valid', (tester) async {
      when(() => mockViewModel.editingStatus).thenReturn(EditingStatus.idle);
      when(() => mockViewModel.selectedCharacter).thenReturn(null);
      when(() => mockViewModel.createCharacter(character: characterSample))
          .thenAnswer((_) async {});
      when(() => mockViewModel.addListener(any())).thenReturn(null);
      when(() => mockViewModel.removeListener(any())).thenReturn(null);

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      await tester.enterText(
          find.byType(TextFormField).at(0), characterSample.name);
      await tester.enterText(
          find.byType(TextFormField).at(2), characterSample.status);
      await tester.enterText(
          find.byType(TextFormField).at(3), characterSample.species);
      await tester.enterText(
          find.byType(TextFormField).at(5), characterSample.gender);
      await tester.enterText(
          find.byType(TextFormField).at(6), characterSample.origin);
      await tester.enterText(
          find.byType(TextFormField).at(7), characterSample.location);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => mockViewModel.editingStatus).called(1);
    });

    testWidgets('should show delete confirmation dialog', (tester) async {
      when(() => mockViewModel.editingStatus).thenReturn(EditingStatus.idle);
      when(() => mockViewModel.selectedCharacter).thenReturn(characterSample);
      when(() => mockViewModel.loadCharacterById(id: 1))
          .thenAnswer((_) async {});
      when(() => mockViewModel.addListener(any())).thenReturn(null);
      when(() => mockViewModel.removeListener(any())).thenReturn(null);

      await tester.pumpWidget(makeTestableWidget(characterId: 1));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Character'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this character?'),
          findsOneWidget);
      verify(() => mockViewModel.editingStatus).called(1);
      verify(() => mockViewModel.loadCharacterById(id: 1)).called(1);
    });
  });
}
