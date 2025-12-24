import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/pokemon_detail/presentation/bloc/pokemon_detail_bloc.dart';
import 'package:pokedex_app/features/pokemon_detail/presentation/widgets/evolution_chain_section.dart';
import 'package:pokedex_app/features/pokemon_detail/presentation/widgets/pokemon_info_section.dart';
import 'package:pokedex_app/features/pokemon_detail/presentation/widgets/pokemon_stats_section.dart';
import 'package:pokedex_app/features/pokemon_detail/presentation/widgets/pokemon_types_section.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_error_view.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/widgets/pokemon_loading_indicator.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({
    required this.pokemonId,
    required this.pokemonName,
    required this.imageUrl,
    super.key,
  });

  final int pokemonId;
  final String pokemonName;
  final String imageUrl;

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _handleRetryDetail(BuildContext context) {
    context.read<PokemonDetailBloc>().add(
      PokemonDetailEvent.loadDetail(pokemonId),
    );
  }

  void _handleRetryEvolution(BuildContext context) {
    context.read<PokemonDetailBloc>().add(
      PokemonDetailEvent.loadEvolution(pokemonId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.red[600],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _capitalize(pokemonName),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[600]!, Colors.red[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'pokemon_$pokemonName',
                    child: Image.network(
                      imageUrl,
                      width: 200,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.catching_pokemon,
                          size: 120,
                          color: Colors.white.withValues(alpha: 0.5),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
              builder: (context, state) {
                // Loading State
                if (state.isLoadingDetail) {
                  return const SizedBox(
                    height: 400,
                    child: LoadingIndicator(
                      message: 'Loading Pokémon details...',
                    ),
                  );
                }

                // Error State
                if (state.detailErrorMessage != null) {
                  return SizedBox(
                    height: 400,
                    child: ErrorView(
                      message: state.detailErrorMessage!,
                      onRetry: () => _handleRetryDetail(context),
                    ),
                  );
                }

                // Success State
                final detail = state.pokemonDetail;
                if (detail == null) {
                  return const SizedBox(
                    height: 400,
                    child: ErrorView(
                      message: 'Failed to load Pokémon details',
                    ),
                  );
                }

                return Column(
                  children: [
                    const SizedBox(height: 16),

                    // Types Section
                    PokemonTypesSection(types: detail.types),

                    const SizedBox(height: 16),

                    // Basic Info Section
                    PokemonInfoSection(detail: detail),

                    const SizedBox(height: 16),

                    // Stats Section
                    PokemonStatsSection(stats: detail.stats),

                    const SizedBox(height: 16),

                    // Evolution Chain Section
                    BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
                      builder: (context, state) {
                        if (state.isLoadingEvolution) {
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: LoadingIndicator(
                              message: 'Loading evolution chain...',
                              isSmall: true,
                            ),
                          );
                        }

                        if (state.evolutionErrorMessage != null) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: ErrorView(
                              message: state.evolutionErrorMessage!,
                              onRetry: () => _handleRetryEvolution(context),
                            ),
                          );
                        }

                        if (state.evolutionChain == null) {
                          return const SizedBox.shrink();
                        }

                        return EvolutionChainSection(
                          chain: state.evolutionChain!,
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
