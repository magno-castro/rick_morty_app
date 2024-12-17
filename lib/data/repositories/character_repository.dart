import 'package:rick_morty_app/core/failures/connection_failure.dart';
import 'package:rick_morty_app/core/utils/network_info.dart';

import '../models/character_model.dart';
import '../services/i_character_service.dart';
import 'i_character_repository.dart';

class CharacterRepository implements ICharacterRepository {
  final ICharacterService _service;
  final INetworkInfo _networkInfo;

  CharacterRepository(this._service, this._networkInfo);

  @override
  Future<List<CharacterModel>> characters({int? page}) async {
    if (await _networkInfo.isConnected) {
      return _service.characters(page: page);
    } else {
      throw const NoConnectionFailure();
    }
  }

  @override
  Future<CharacterModel> characterById({required int id}) async {
    assert(id > 0, 'Id must be greater than 0');

    if (await _networkInfo.isConnected) {
      return _service.characterById(id: id);
    } else {
      throw const NoConnectionFailure();
    }
  }

  @override
  Future<List<CharacterModel>> filterCharactersByName(
      {required String name, int? page}) async {
    assert(name.isNotEmpty, 'Name cannot be empty');

    if (await _networkInfo.isConnected) {
      return _service.filterCharactersByName(name: name, page: page);
    } else {
      throw const NoConnectionFailure();
    }
  }

  @override
  Future<void> createCharacter(
      {required CharacterModel character}) async {
    if (await _networkInfo.isConnected) {
      return _service.createCharacter(character: character);
    } else {
      throw const NoConnectionFailure();
    }
  }

  @override
  Future<void> updateCharacter(
      {required CharacterModel character}) async {
    if (await _networkInfo.isConnected) {
      return _service.updateCharacter(character: character);
    } else {
      throw const NoConnectionFailure();
    }
  }

  @override
  Future<void> deleteCharacter({required int id}) async {
    assert(id > 0, 'Id must be greater than 0');

    if (await _networkInfo.isConnected) {
      return _service.deleteCharacter(id: id);
    } else {
      throw const NoConnectionFailure();
    }
  }
}
