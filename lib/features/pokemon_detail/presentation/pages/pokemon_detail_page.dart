import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_app/features/pokemon_detail/presentation/bloc/pokemon_detail_bloc.dart';
import 'package:pokedex_app/features/pokemon_detail/presentation/widgets/pokemon_detail_screen.dart';

class PokemonDetailPage extends StatelessWidget {
  final int pokemonId;
  final String pokemonName;
  final String imageUrl;

  const PokemonDetailPage({
    super.key,
    required this.pokemonId,
    required this.pokemonName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PokemonDetailBloc>()
        ..add(PokemonDetailEvent.loadDetail(pokemonId))
        ..add(PokemonDetailEvent.loadEvolution(pokemonId)),
      child: PokemonDetailScreen(
        pokemonId: pokemonId,
        pokemonName: pokemonName,
        imageUrl: imageUrl,
      ),
    );
  }
}
