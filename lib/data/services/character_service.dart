import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_morty_app/core/failures/api_failure.dart';

import '../models/character_model.dart';
import 'i_character_service.dart';

class CharacterService implements ICharacterService {
  final String apiUrl;
  final http.Client _client;

  const CharacterService(this._client, [String? url])
      : apiUrl = url ?? const String.fromEnvironment('API_URL');

  @override
  Future<List<CharacterModel>> characters({int? page}) async {
    final response = await _client.get(
      Uri.parse('$apiUrl/characters').replace(
        queryParameters: page != null ? {'page': page.toString()} : null,
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          json.decode(utf8.decode(response.bodyBytes))['results'];
      return jsonList.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw ApiFailure(
        statusCode: response.statusCode,
        message: 'Failed to load characters',
        serverResponseBody: response.body,
      );
    }
  }

  @override
  Future<CharacterModel> characterById({required int id}) async {
    final response = await _client.get(Uri.parse('$apiUrl/characters/$id'));

    if (response.statusCode == 200) {
      return CharacterModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw ApiFailure(
        statusCode: response.statusCode,
        message: 'Failed to load character',
        serverResponseBody: response.body,
      );
    }
  }

  @override
  Future<List<CharacterModel>> filterCharactersByName(
      {required String name, int? page}) async {
    final response = await _client.get(
      Uri.parse('$apiUrl/characters').replace(
        queryParameters: {
          'name': name,
          if (page != null) 'page': page.toString(),
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          json.decode(utf8.decode(response.bodyBytes))['results'];
      return jsonList.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw ApiFailure(
        statusCode: response.statusCode,
        message: 'Failed to search characters',
        serverResponseBody: response.body,
      );
    }
  }

  @override
  Future<void> createCharacter({required CharacterModel character}) async {
    final response = await _client.post(
      Uri.parse('$apiUrl/characters/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(character.toJson()),
    );

    if (response.statusCode != 201) {
      throw ApiFailure(
        statusCode: response.statusCode,
        message: jsonDecode(response.body)['message'],
        serverResponseBody: response.body,
      );
    }
  }

  @override
  Future<void> updateCharacter({required CharacterModel character}) async {
    final response = await _client.put(
      Uri.parse('$apiUrl/characters/${character.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(character.toJson()),
    );

    if (response.statusCode >= 400) {
      throw ApiFailure(
        statusCode: response.statusCode,
        message: jsonDecode(response.body)['message'],
        serverResponseBody: response.body,
      );
    }
  }

  @override
  Future<void> deleteCharacter({required int id}) async {
    final response = await _client.delete(
      Uri.parse('$apiUrl/characters/$id'),
    );

    if (response.statusCode != 200) {
      throw ApiFailure(
        statusCode: response.statusCode,
        message: jsonDecode(response.body)['message'],
        serverResponseBody: response.body,
      );
    }
  }
}
