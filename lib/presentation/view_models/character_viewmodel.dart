import 'package:flutter/foundation.dart';
import 'package:rick_morty_app/core/failures/api_failure.dart';
import 'package:rick_morty_app/core/failures/connection_failure.dart';
import 'package:rick_morty_app/core/utils/error_report.dart';

import '../../data/models/character_model.dart';
import '../../data/repositories/i_character_repository.dart';

enum EditingStatus {
  idle,
  loading,
  completed,
}

class CharacterViewModel extends ChangeNotifier {
  final ICharacterRepository _repository;

  final List<CharacterModel> _characters = [];
  CharacterModel? _selectedCharacter;
  bool _isListLoading = false;
  bool _hasMorePage = true;
  EditingStatus _editingStatus = EditingStatus.idle;
  String? _listError;
  String? _editingError;

  var _page = 1;

  List<CharacterModel> get characters => _characters;
  CharacterModel? get selectedCharacter => _selectedCharacter;
  bool get isListLoading => _isListLoading;
  EditingStatus get editingStatus => _editingStatus;
  String? get listError => _listError;
  String? get editingError => _editingError;
  bool get hasMorePage => _hasMorePage;
  int get page => _page;

  CharacterViewModel(this._repository);

  Future<void> loadCharacters({int page = 1}) async {
    if (page == 1) {
      _isListLoading = true;
      _hasMorePage = true;
      _characters.clear();
    }
    _listError = null;
    notifyListeners();

    try {
      final characters = await _repository.characters(page: page);

      if (characters.isNotEmpty) {
        _characters.addAll(characters);
      } else {
        _hasMorePage = false;
      }

      _page = page + 1;
    } on ApiFailure catch (e, s) {
      _listError = e.message;

      reportError(
        error: e,
        stackTrace: s,
        extra: {'serverBody': e.serverResponseBody},
      );
    } on NoConnectionFailure catch (e) {
      _listError = e.message;
    } catch (e, s) {
      _listError = e.toString();

      reportError(error: e, stackTrace: s);
    } finally {
      _isListLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCharacterById({required int id}) async {
    _editingStatus = EditingStatus.loading;
    _editingError = null;
    notifyListeners();

    try {
      _selectedCharacter = await _repository.characterById(id: id);
    } on ApiFailure catch (e, s) {
      _editingError = e.message;

      reportError(
        error: e,
        stackTrace: s,
        extra: {'serverBody': e.serverResponseBody},
      );
    } on NoConnectionFailure catch (e) {
      _editingError = e.message;
    } catch (e, s) {
      _editingError = e.toString();

      reportError(error: e, stackTrace: s);
    } finally {
      _editingStatus = EditingStatus.idle;
      notifyListeners();
    }
  }

  Future<void> filterCharacters({required String name, int page = 1}) async {
    if (page == 1) {
      _isListLoading = true;
      _hasMorePage = true;
      _characters.clear();
    }
    _listError = null;
    notifyListeners();

    try {
      final characters =
          await _repository.filterCharactersByName(name: name, page: page);

      if (characters.isNotEmpty) {
        _characters.addAll(characters);
      } else {
        _hasMorePage = false;
      }

      _page = page + 1;
    } on ApiFailure catch (e, s) {
      _listError = e.message;
      reportError(
        error: e,
        stackTrace: s,
        extra: {'serverBody': e.serverResponseBody},
      );
    } on NoConnectionFailure catch (e) {
      _listError = e.message;
    } catch (e, s) {
      _listError = e.toString();
      reportError(error: e, stackTrace: s);
    } finally {
      _isListLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCharacter({required CharacterModel character}) async {
    _editingStatus = EditingStatus.loading;
    _editingError = null;
    notifyListeners();

    try {
      await _repository.createCharacter(character: character);
      _editingStatus = EditingStatus.completed;
      await loadCharacters();
    } on ApiFailure catch (e, s) {
      _editingError = e.message;

      reportError(
        error: e,
        stackTrace: s,
        extra: {'serverBody': e.serverResponseBody},
      );
    } on NoConnectionFailure catch (e) {
      _editingError = e.message;
    } catch (e, s) {
      _editingError = e.toString();

      reportError(error: e, stackTrace: s);
    } finally {
      if (_editingError is String) {
        _editingStatus = EditingStatus.idle;
      }

      notifyListeners();
    }
  }

  Future<void> updateCharacter({required CharacterModel character}) async {
    _editingStatus = EditingStatus.loading;
    _editingError = null;
    notifyListeners();

    try {
      await _repository.updateCharacter(character: character);
      _editingStatus = EditingStatus.completed;
      await loadCharacters();
    } on ApiFailure catch (e, s) {
      _editingError = e.message;

      reportError(
        error: e,
        stackTrace: s,
        extra: {'serverBody': e.serverResponseBody},
      );
    } on NoConnectionFailure catch (e) {
      _editingError = e.message;
    } catch (e, s) {
      _editingError = e.toString();

      reportError(error: e, stackTrace: s);
    } finally {
      if (_editingError is String) {
        _editingStatus = EditingStatus.idle;
      }
      notifyListeners();
    }
  }

  Future<void> deleteCharacter({required int id}) async {
    _editingStatus = EditingStatus.loading;
    _editingError = null;
    notifyListeners();

    try {
      await _repository.deleteCharacter(id: id);
      _editingStatus = EditingStatus.completed;
      await loadCharacters();
    } on ApiFailure catch (e, s) {
      _editingError = e.message;

      reportError(
        error: e,
        stackTrace: s,
        extra: {'serverBody': e.serverResponseBody},
      );
    } on NoConnectionFailure catch (e) {
      _editingError = e.message;
    } catch (e, s) {
      _editingError = e.toString();

      reportError(error: e, stackTrace: s);
    } finally {
      if (_editingError is String) {
        _editingStatus = EditingStatus.idle;
      }
      notifyListeners();
    }
  }

  void clearCharacterDetail() {
    _selectedCharacter = null;
    _editingStatus = EditingStatus.idle;
    clearEditingError();
    notifyListeners();
  }

  void clearListError() {
    _listError = null;
    notifyListeners();
  }

  void clearEditingError() {
    _editingError = null;
    notifyListeners();
  }
}
