import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_app/features/battle_arena/presentation/pages/battle_page.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/bloc/pokemon_list_bloc.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_loading_indicator.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_search_bar.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_type_filter.dart';

class PokemonSelectionScreen extends StatefulWidget {
  const PokemonSelectionScreen({super.key});

  @override
  State<PokemonSelectionScreen> createState() => _PokemonSelectionScreenState();
}

class _PokemonSelectionScreenState extends State<PokemonSelectionScreen> {
  int? _selectedPlayerPokemon;
  int? _selectedOpponentPokemon;
  String _currentSelection = 'player';

  int _extractPokemonId(String imageUrl) {
    // Extract ID from URL: https://raw.githubusercontent.com/.../pokemon/25.png
    final regex = RegExp(r'/(\d+)\.png$');
    final match = regex.firstMatch(imageUrl);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 0;
  }

  void _handleSearch(BuildContext context, String query) {
    if (query.isEmpty) {
      context.read<PokemonListBloc>().add(const PokemonListEvent.fetch());
    } else {
      context.read<PokemonListBloc>().add(PokemonListEvent.search(query));
    }
  }

  void _handleTypeFilter(BuildContext context, String? type) {
    if (type == null) {
      context.read<PokemonListBloc>().add(const PokemonListEvent.fetch());
    } else {
      context.read<PokemonListBloc>().add(PokemonListEvent.getByType(type));
    }
  }

  Future<void> _handlePokemonSelection(int pokemonId) async {
    setState(() {
      if (_currentSelection == 'player') {
        _selectedPlayerPokemon = pokemonId;
        if (_selectedOpponentPokemon == null) {
          _currentSelection = 'opponent';
        }
      } else {
        _selectedOpponentPokemon = pokemonId;
      }
    });

    // Auto-start battle if both selected
    if (_selectedPlayerPokemon != null && _selectedOpponentPokemon != null) {
      await _startBattle();
    }
  }

  Future<void> _startBattle() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BattlePage(
          playerPokemonId: _selectedPlayerPokemon!,
          opponentPokemonId: _selectedOpponentPokemon!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PokemonListBloc>()
        ..add(const PokemonListEvent.fetch())
        ..add(const PokemonListEvent.fetchTypes()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Select Battle Pokemon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red[600],
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[600]!, Colors.red[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Selection Status Bar
            _buildSelectionStatusBar(),

            // Search & Filter
            PokemonSearchBar(
              onSearch: (query) => _handleSearch(context, query),
              onClear: () => _handleSearch(context, ''),
            ),
            PokemonTypeFilter(
              onTypeSelected: (type) => _handleTypeFilter(context, type),
            ),

            // Pokemon Grid
            Expanded(
              child: BlocBuilder<PokemonListBloc, PokemonListState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const LoadingIndicator(
                      message: 'Loading Pokemon...',
                    );
                  }

                  if (state.pokemons.isEmpty) {
                    return const Center(
                      child: Text('No Pokemon found'),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!state.hasReachedMax &&
                          !state.isLoadingMore &&
                          scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent * 0.9) {
                        context.read<PokemonListBloc>().add(
                          const PokemonListEvent.loadMore(),
                        );
                      }
                      return false;
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                      itemCount:
                          state.pokemons.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.pokemons.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final pokemon = state.pokemons[index];
                        final pokemonId = _extractPokemonId(pokemon.imageUrl);
                        final isPlayerSelected =
                            _selectedPlayerPokemon == pokemonId;
                        final isOpponentSelected =
                            _selectedOpponentPokemon == pokemonId;

                        return _buildPokemonCard(
                          pokemonName: pokemon.name,
                          pokemonImageUrl: pokemon.imageUrl,
                          pokemonId: pokemonId,
                          isPlayerSelected: isPlayerSelected,
                          isOpponentSelected: isOpponentSelected,
                          onTap: () => _handlePokemonSelection(pokemonId),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionStatusBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSelectionChip(
              label: 'Your Pokemon',
              pokemonId: _selectedPlayerPokemon,
              isActive: _currentSelection == 'player',
              color: Colors.blue,
              onTap: () => setState(() => _currentSelection = 'player'),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[600],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flash_on,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSelectionChip(
              label: 'Opponent',
              pokemonId: _selectedOpponentPokemon,
              isActive: _currentSelection == 'opponent',
              color: Colors.red,
              onTap: () => setState(() => _currentSelection = 'opponent'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionChip({
    required String label,
    required int? pokemonId,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : Colors.grey[300]!,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? color : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              pokemonId != null ? '#$pokemonId' : 'Tap to select',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: pokemonId != null ? color : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard({
    required String pokemonName,
    required String pokemonImageUrl,
    required int pokemonId,
    required bool isPlayerSelected,
    required bool isOpponentSelected,
    required VoidCallback onTap,
  }) {
    Color? borderColor;
    double borderWidth = 1;

    if (isPlayerSelected) {
      borderColor = Colors.blue;
      borderWidth = 3;
    } else if (isOpponentSelected) {
      borderColor = Colors.red;
      borderWidth = 3;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? Colors.grey[300]!,
            width: borderWidth,
          ),
          boxShadow: [
            if (isPlayerSelected || isOpponentSelected)
              BoxShadow(
                color: (borderColor ?? Colors.grey).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isPlayerSelected || isOpponentSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPlayerSelected ? 'YOU' : 'OPP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Image.network(
              pokemonImageUrl,
              height: 60,
              width: 60,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.catching_pokemon,
                  size: 60,
                  color: Colors.grey[400],
                );
              },
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                pokemonName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '#$pokemonId',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
