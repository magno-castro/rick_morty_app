import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty_app/core/utils/debouncer.dart';
import 'package:rick_morty_app/presentation/widgets/character_avatar.dart';

import '../../data/models/character_model.dart';
import '../view_models/character_viewmodel.dart';

class CharacterDetailPage extends StatefulWidget {
  final int? characterId;

  const CharacterDetailPage({super.key, this.characterId});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late final CharacterViewModel _viewModel;
  late final Stream<String> _imageStream;

  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _statusController = TextEditingController();
  final _speciesController = TextEditingController();
  final _typeController = TextEditingController();
  final _genderController = TextEditingController();
  final _originController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageStreamController = StreamController<String>();
  final _debouncer = Debouncer();

  CharacterModel? _character;

  @override
  void initState() {
    super.initState();

    _imageStream = _imageStreamController.stream.asBroadcastStream();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = context.read<CharacterViewModel>();

      if (widget.characterId case int characterId) {
        _viewModel.loadCharacterById(id: characterId);
      }

      _viewModel
        ..addListener(_editingCompleted)
        ..addListener(_errorListener);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _speciesController.dispose();
    _typeController.dispose();
    _genderController.dispose();
    _originController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _viewModel.removeListener(_errorListener);
    _viewModel.removeListener(_editingCompleted);
    _imageStreamController.close();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        _viewModel.clearCharacterDetail();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.characterId == null
                ? 'Create Character'
                : 'Edit Character'),
            actions: [
              if (widget.characterId != null)
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  icon: const Icon(Icons.delete),
                ),
            ]),
        body: Consumer<CharacterViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.editingStatus == EditingStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.selectedCharacter case CharacterModel character) {
              _character = character;
              _nameController.text = character.name;
              _statusController.text = character.status;
              _speciesController.text = character.species;
              _typeController.text = character.type;
              _genderController.text = character.gender;
              _originController.text = character.origin;
              _locationController.text = character.location;
              _imageUrlController.text = character.image;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    StreamBuilder<String>(
                        stream: _imageStream,
                        initialData: _imageUrlController.text,
                        builder: (context, snapshot) {
                          return CharacterAvatar(
                              image: snapshot.data,
                              borderRadius: BorderRadius.circular(16));
                        }),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Name is required' : null,
                    ),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      onChanged: (value) {
                        _debouncer.run(() {
                          _imageStreamController.add(value);
                        });
                      },
                    ),
                    TextFormField(
                      controller: _statusController,
                      decoration: const InputDecoration(labelText: 'Status'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Status is required' : null,
                    ),
                    TextFormField(
                      controller: _speciesController,
                      decoration: const InputDecoration(labelText: 'Species'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Species is required' : null,
                    ),
                    TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                    TextFormField(
                      controller: _genderController,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Gender is required' : null,
                    ),
                    TextFormField(
                      controller: _originController,
                      decoration: const InputDecoration(labelText: 'Origin'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Origin is required' : null,
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Location is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final character = CharacterModel(
                            id: _character?.id ?? 0,
                            name: _nameController.text,
                            status: _statusController.text,
                            species: _speciesController.text,
                            type: _typeController.text,
                            gender: _genderController.text,
                            origin: _originController.text,
                            location: _locationController.text,
                            image: _imageUrlController.text,
                            source: _character?.source ?? '',
                          );

                          if (_character == null) {
                            context
                                .read<CharacterViewModel>()
                                .createCharacter(character: character);
                          } else {
                            context
                                .read<CharacterViewModel>()
                                .updateCharacter(character: character);
                          }
                        }
                      },
                      child: Text(_character == null ? 'Create' : 'Update'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _editingCompleted() {
    if (_viewModel.editingStatus == EditingStatus.completed) {
      Navigator.pop(context);
    }
  }

  void _errorListener() {
    if (_viewModel.editingError != null) {
      _showErrorDialog(_viewModel.editingError!);
      _viewModel.clearEditingError();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: const Text('Are you sure you want to delete this character?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _viewModel.deleteCharacter(id: widget.characterId!);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
