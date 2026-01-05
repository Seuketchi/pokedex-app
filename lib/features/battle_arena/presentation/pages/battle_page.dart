import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_app/features/battle_arena/presentation/bloc/battle_bloc.dart';
import 'package:pokedex_app/features/battle_arena/presentation/widgets/battle_screen.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({
    required this.playerPokemonId,
    required this.opponentPokemonId,
    super.key,
  });

  final int playerPokemonId;
  final int opponentPokemonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<BattleBloc>()
        ..add(
          BattleEvent.initializeBattle(
            playerPokemonId: playerPokemonId,
            opponentPokemonId: opponentPokemonId,
          ),
        ),
      child: const BattleScreen(),
    );
  }
}
