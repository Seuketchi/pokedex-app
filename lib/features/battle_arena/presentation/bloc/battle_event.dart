part of 'battle_bloc.dart';

@freezed
class BattleEvent with _$BattleEvent {
  const factory BattleEvent.initializeBattle({
    required int playerPokemonId,
    required int opponentPokemonId,
  }) = _InitializeBattle;

  const factory BattleEvent.executeMove({
    required Move move,
  }) = _ExecuteMove;

  const factory BattleEvent.reset() = _Reset;
}
