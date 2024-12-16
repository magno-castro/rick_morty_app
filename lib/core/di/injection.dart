import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rick_morty_app/core/utils/network_info.dart';
import 'package:rick_morty_app/data/repositories/character_repository.dart';
import 'package:rick_morty_app/data/repositories/i_character_repository.dart';
import 'package:rick_morty_app/data/services/character_service.dart';
import 'package:rick_morty_app/data/services/i_character_service.dart';
import 'package:http/http.dart' as http;

final di = GetIt.instance;

void setupInjection() {
  di.registerLazySingleton<INetworkInfo>(
      () => NetworkInfo(connectionChecker: InternetConnection()));
  di.registerLazySingleton<ICharacterService>(
      () => CharacterService(http.Client()));

  di.registerLazySingleton<ICharacterRepository>(
      () => CharacterRepository(di(), di()));
}
