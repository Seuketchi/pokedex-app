import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_ability.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_type.dart';

part 'pokemon_detail.freezed.dart';

@freezed
class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    required int id,
    required String name,
    required List<PokemonType> types,
    required int height,
    required int weight,
    required int baseExperience,
    required List<PokemonStat> stats,
    required List<PokemonAbility> abilities,
    required PokemonSprites sprites,
  }) = _PokemonDetail;
}
