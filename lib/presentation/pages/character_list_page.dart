import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty_app/core/utils/debouncer.dart';

import '../view_models/character_viewmodel.dart';
import '../widgets/character_card.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final _searchController = TextEditingController();
  final _searchDebouncer = Debouncer();
  final _scrollController = ScrollController();
  final _paginationDebouncer = Debouncer();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterViewModel>().loadCharacters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    _paginationDebouncer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick & Morty Characters'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/detail'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search characters...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _searchDebouncer.run(() {
                    context
                        .read<CharacterViewModel>()
                        .filterCharacters(name: value);
                  });
                } else {
                  _searchDebouncer.dispose();
                  context.read<CharacterViewModel>().loadCharacters();
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<CharacterViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (viewModel.listError != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(viewModel.listError!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.loadCharacters(),
                        child: const Text('Try Again'),
                      ),
                    ],
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.characters.length +
                        (viewModel.hasMorePage ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == viewModel.characters.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final character = viewModel.characters[index];
                      return CharacterCard(
                        character: character,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: {'id': character.id},
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      _paginationDebouncer.run(() {
        final viewModel = context.read<CharacterViewModel>();
        if (_searchController.text.isEmpty) {
          viewModel.loadCharacters(page: viewModel.page);
        } else {
          viewModel.filterCharacters(
              name: _searchController.text, page: viewModel.page);
        }
      });
    }
  }
}
