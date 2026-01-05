import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_moves_response.freezed.dart';
part 'pokemon_moves_response.g.dart';

@freezed
class PokemonMovesResponse with _$PokemonMovesResponse {
  const factory PokemonMovesResponse({
    required List<PokemonMoveSlot> moves,
  }) = _PokemonMovesResponse;

  factory PokemonMovesResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonMovesResponseFromJson(json);
}

@freezed
class PokemonMoveSlot with _$PokemonMoveSlot {
  const factory PokemonMoveSlot({
    required MoveInfoModel move,
  }) = _PokemonMoveSlot;

  factory PokemonMoveSlot.fromJson(Map<String, dynamic> json) =>
      _$PokemonMoveSlotFromJson(json);
}

@freezed
class MoveInfoModel with _$MoveInfoModel {
  const factory MoveInfoModel({
    required String name,
    required String url,
  }) = _MoveInfoModel;

  factory MoveInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MoveInfoModelFromJson(json);
}
