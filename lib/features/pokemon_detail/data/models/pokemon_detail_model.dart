import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_ability_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_stat_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_type_model.dart';

part 'pokemon_detail_model.freezed.dart';
part 'pokemon_detail_model.g.dart';

@freezed
class PokemonDetailModel with _$PokemonDetailModel {
  const factory PokemonDetailModel({
    required int id,
    required String name,
    required List<PokemonTypeModel> types,
    required int height,
    required int weight,
    @JsonKey(name: 'base_experience') required int baseExperience,
    required List<PokemonStatModel> stats,
    required List<PokemonAbilityModel> abilities,
    required PokemonSpritesModel sprites,
  }) = _PokemonDetailModel;

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailModelFromJson(json);
}
