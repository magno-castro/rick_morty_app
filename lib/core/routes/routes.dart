import 'package:flutter/material.dart';
import 'package:rick_morty_app/presentation/pages/character_detail_page.dart';
import 'package:rick_morty_app/presentation/pages/character_list_page.dart';

class Routes {
  static const String home = '/';
  static const String detail = '/detail';

  static Map<String, WidgetBuilder> routes() {
    return {
      home: (context) => const CharacterListPage(),
      detail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        return CharacterDetailPage(characterId: args?['id']);
      },
    };
  }
}
