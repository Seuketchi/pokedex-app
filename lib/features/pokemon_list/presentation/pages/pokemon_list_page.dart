import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/bloc/pokemon_list_bloc.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_empty_view.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_error_view.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_list_view.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_loading_indicator.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_search_bar.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_type_filter.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PokemonListBloc>()
        ..add(const PokemonListEvent.fetch())
        ..add(const PokemonListEvent.fetchTypes()),
      child: const _PokemonListView(),
    );
  }
}

class _PokemonListView extends StatelessWidget {
  const _PokemonListView();

  void _handleSearch(BuildContext context, String query) {
    if (query.isEmpty) {
      context.read<PokemonListBloc>().add(const PokemonListEvent.fetch());
    } else {
      context.read<PokemonListBloc>().add(
        PokemonListEvent.search(query),
      );
    }
  }

  void _handleClearSearch(BuildContext context) {
    context.read<PokemonListBloc>().add(const PokemonListEvent.fetch());
  }

  void _handleTypeFilter(BuildContext context, String? type) {
    if (type == null) {
      context.read<PokemonListBloc>().add(const PokemonListEvent.fetch());
    } else {
      context.read<PokemonListBloc>().add(
        PokemonListEvent.getByType(type),
      );
    }
  }

  void _handleLoadMore(BuildContext context) {
    context.read<PokemonListBloc>().add(const PokemonListEvent.loadMore());
  }

  void _handleRetry(BuildContext context) {
    context.read<PokemonListBloc>().add(const PokemonListEvent.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.catching_pokemon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Pokédex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
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
          PokemonSearchBar(
            onSearch: (query) => _handleSearch(context, query),
            onClear: () => _handleClearSearch(context),
          ),
          PokemonTypeFilter(
            onTypeSelected: (type) => _handleTypeFilter(context, type),
          ),
          Expanded(
            child: BlocBuilder<PokemonListBloc, PokemonListState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const LoadingIndicator(
                    message: 'Catching Pokémon...',
                  );
                }

                if (state.errorMessage != null) {
                  return ErrorView(
                    message: state.errorMessage!,
                    onRetry: () => _handleRetry(context),
                  );
                }

                if (state.pokemons.isEmpty) {
                  return EmptyStateView(
                    subtitle: 'Try searching for a different Pokémon or type',
                    actionLabel: 'Show All',
                    onAction: () => _handleClearSearch(context),
                  );
                }

                return PokemonListView(
                  pokemons: state.pokemons
                      .map(
                        (pokemon) => PokemonItemData(
                          name: pokemon.name,
                          imageUrl: pokemon.imageUrl,
                        ),
                      )
                      .toList(),
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: () => _handleLoadMore(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
