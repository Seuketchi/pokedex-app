import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_ability_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_sprites_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_stat_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_type_model.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_ability.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_type.dart';

extension PokemonDetailMapper on PokemonDetailModel {
  PokemonDetail toDomain() {
    return PokemonDetail(
      id: id,
      name: name,
      types: types.map((t) => t.toDomain()).toList(),
      height: height,
      weight: weight,
      baseExperience: baseExperience,
      stats: stats.map((s) => s.toDomain()).toList(),
      abilities: abilities.map((a) => a.toDomain()).toList(),
      sprites: sprites.toDomain(),
    );
  }
}

extension PokemonTypeModelMapper on PokemonTypeModel {
  PokemonType toDomain() {
    return PokemonType(
      name: type.name,
      slot: slot,
    );
  }
}

extension PokemonStatModelMapper on PokemonStatModel {
  PokemonStat toDomain() {
    return PokemonStat(
      name: stat.name,
      baseStat: baseStat,
      effort: effort,
    );
  }
}

extension PokemonAbilityModelMapper on PokemonAbilityModel {
  PokemonAbility toDomain() {
    return PokemonAbility(
      name: ability.name,
      isHidden: isHidden,
      slot: slot,
    );
  }
}

extension PokemonSpritesModelMapper on PokemonSpritesModel {
  PokemonSprites toDomain() {
    return PokemonSprites(
      frontDefault: frontDefault ?? '',
      frontShiny: frontShiny,
      backDefault: backDefault,
      backShiny: backShiny,
    );
  }
}
