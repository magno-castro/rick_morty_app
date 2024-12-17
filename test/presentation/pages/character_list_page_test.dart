import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty_app/presentation/pages/character_list_page.dart';
import 'package:rick_morty_app/presentation/view_models/character_viewmodel.dart';
import '../../fixtures/sample/character_sample.dart';

class MockCharacterViewModel extends Mock implements CharacterViewModel {}

void main() {
  late MockCharacterViewModel mockViewModel;

  Widget makeTestableWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<CharacterViewModel>.value(
        value: mockViewModel,
        child: const CharacterListPage(),
      ),
    );
  }

  setUp(() {
    mockViewModel = MockCharacterViewModel();
  });

  group('CharacterListPage =>', () {
    testWidgets('should display loading indicator when loading',
        (tester) async {
      when(() => mockViewModel.isListLoading).thenReturn(true);
      when(() => mockViewModel.characters).thenReturn([]);
      when(() => mockViewModel.hasMorePage).thenReturn(true);
      when(() => mockViewModel.loadCharacters()).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(() => mockViewModel.isListLoading);
      verify(() => mockViewModel.loadCharacters());
    });

    testWidgets('should display error message when there is an error',
        (tester) async {
      when(() => mockViewModel.isListLoading).thenReturn(false);
      when(() => mockViewModel.characters).thenReturn([]);
      when(() => mockViewModel.hasMorePage).thenReturn(true);
      when(() => mockViewModel.listError).thenReturn('Error message');
      when(() => mockViewModel.loadCharacters()).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(find.text('Error message'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      verify(() => mockViewModel.isListLoading);
      verify(() => mockViewModel.listError);
      verify(() => mockViewModel.loadCharacters());
    });

    testWidgets('should display character list when data is loaded',
        (tester) async {
      when(() => mockViewModel.isListLoading).thenReturn(false);
      when(() => mockViewModel.characters).thenReturn([characterSample]);
      when(() => mockViewModel.hasMorePage).thenReturn(false);
      when(() => mockViewModel.listError).thenReturn(null);
      when(() => mockViewModel.loadCharacters()).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);

      verify(() => mockViewModel.isListLoading);
      verify(() => mockViewModel.characters);
      verify(() => mockViewModel.hasMorePage);
      verify(() => mockViewModel.loadCharacters());
    });

    testWidgets('should trigger search when text is entered', (tester) async {
      when(() => mockViewModel.isListLoading).thenReturn(false);
      when(() => mockViewModel.characters).thenReturn([]);
      when(() => mockViewModel.hasMorePage).thenReturn(true);
      when(() => mockViewModel.filterCharacters(name: 'Rick'))
          .thenAnswer((_) async {});
      when(() => mockViewModel.loadCharacters()).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField), 'Rick');
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockViewModel.filterCharacters(name: 'Rick'));
      verify(() => mockViewModel.isListLoading);
      verify(() => mockViewModel.loadCharacters());
    });

    testWidgets('should navigate to detail page when FAB is pressed',
        (tester) async {
      when(() => mockViewModel.isListLoading).thenReturn(false);
      when(() => mockViewModel.characters).thenReturn([]);
      when(() => mockViewModel.hasMorePage).thenReturn(true);
      when(() => mockViewModel.loadCharacters()).thenAnswer((_) async {});

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/detail': (context) => const Scaffold(),
        },
        home: ChangeNotifierProvider<CharacterViewModel>.value(
          value: mockViewModel,
          child: const CharacterListPage(),
        ),
      ));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      verify(() => mockViewModel.isListLoading);
      verify(() => mockViewModel.loadCharacters());
    });

    testWidgets('should load more data when scrolling near bottom',
        (tester) async {
      when(() => mockViewModel.isListLoading).thenReturn(false);
      when(() => mockViewModel.characters)
          .thenReturn(List.generate(20, (index) => characterSample));
      when(() => mockViewModel.hasMorePage).thenReturn(true);
      when(() => mockViewModel.page).thenReturn(2);
      when(() => mockViewModel.loadCharacters(page: 2))
          .thenAnswer((_) async {});
      when(() => mockViewModel.loadCharacters()).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      await tester.dragFrom(const Offset(0, 300), const Offset(0, -300));
      await tester.pump();

      verify(() => mockViewModel.isListLoading);
      verify(() => mockViewModel.characters);
      verify(() => mockViewModel.hasMorePage);
      verify(() => mockViewModel.loadCharacters());
    });
  });
}
