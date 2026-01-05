part of 'battle_bloc.dart';

@freezed
class BattleState with _$BattleState {
  const factory BattleState({
    @Default(false) bool isLoading,
    @Default(false) bool isInitialized,
    @Default(false) bool isBattleOver,
    BattlePokemon? playerPokemon,
    BattlePokemon? opponentPokemon,
    @Default(true) bool isPlayerTurn,
    @Default([]) List<BattleLog> battleLogs,
    BattlePokemon? winner,
    String? errorMessage,
  }) = _BattleState;
}
