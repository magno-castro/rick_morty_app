import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'core/routes/routes.dart';
import 'presentation/view_models/character_viewmodel.dart';

void main() {
  setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterViewModel(di()),
      child: MaterialApp(
        title: 'Rick & Morty App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: Routes.home,
        routes: Routes.routes(),
      ),
    );
  }
}
