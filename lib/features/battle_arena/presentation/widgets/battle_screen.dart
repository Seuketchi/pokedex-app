import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/features/battle_arena/presentation/bloc/battle_bloc.dart';
import 'package:pokedex_app/features/battle_arena/presentation/widgets/battle_log_view.dart';
import 'package:pokedex_app/features/battle_arena/presentation/widgets/battle_result_dialog.dart';
import 'package:pokedex_app/features/battle_arena/presentation/widgets/move_buttons.dart';
import 'package:pokedex_app/features/battle_arena/presentation/widgets/pokemon_battle_card.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Battle Arena',
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
      body: BlocConsumer<BattleBloc, BattleState>(
        listener: (context, state) async {
          if (state.isBattleOver && state.winner != null) {
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) => BattleResultDialog(
                winner: state.winner!,
                onNewBattle: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                onQuit: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red[600]!),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Preparing battle...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[600]),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (!state.isInitialized) {
            return const Center(child: Text('Initializing battle...'));
          }

          return Column(
            children: [
              // Opponent Pokemon
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red[100]!,
                        Colors.grey[200]!,
                      ],
                    ),
                  ),
                  child: Center(
                    child: PokemonBattleCard(
                      pokemon: state.opponentPokemon!,
                      isOpponent: true,
                    ),
                  ),
                ),
              ),

              // Battle Log
              BattleLogView(logs: state.battleLogs),

              // Player Pokemon
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey[200]!,
                        Colors.blue[100]!,
                      ],
                    ),
                  ),
                  child: Center(
                    child: PokemonBattleCard(
                      pokemon: state.playerPokemon!,
                      isOpponent: false,
                    ),
                  ),
                ),
              ),

              // Move Buttons Section - Manual Control for BOTH Pokemon
              if (!state.isBattleOver &&
                  state.playerPokemon != null &&
                  state.opponentPokemon != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Turn Indicator
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: state.isPlayerTurn
                            ? Colors.blue[100]
                            : Colors.red[100],
                        border: Border(
                          top: BorderSide(
                            color: state.isPlayerTurn
                                ? Colors.blue[300]!
                                : Colors.red[300]!,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            state.isPlayerTurn
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: state.isPlayerTurn
                                ? Colors.blue[800]
                                : Colors.red[800],
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.isPlayerTurn
                                ? "${state.playerPokemon!.name.toUpperCase()}'S"
                                      ' TURN'
                                : '${state.opponentPokemon!.name.toUpperCase()}'
                                      "'S TURN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: state.isPlayerTurn
                                  ? Colors.blue[800]
                                  : Colors.red[800],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Move Buttons
                    MoveButtons(
                      moves: state.isPlayerTurn
                          ? state.playerPokemon!.moves
                          : state.opponentPokemon!.moves,
                      onMoveSelected: (move) {
                        context.read<BattleBloc>().add(
                          BattleEvent.executeMove(move: move),
                        );
                      },
                    ),
                  ],
                )
              else if (state.isBattleOver)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Battle Over!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
