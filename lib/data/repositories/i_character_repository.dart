import '../models/character_model.dart';

abstract class ICharacterRepository {
  Future<List<CharacterModel>> characters({int? page});
  Future<CharacterModel> characterById({required int id});
  Future<List<CharacterModel>> filterCharactersByName({required String name, int? page});
  Future<void> createCharacter({required CharacterModel character});
  Future<void> updateCharacter({required CharacterModel character});
  Future<void> deleteCharacter({required int id});
}
