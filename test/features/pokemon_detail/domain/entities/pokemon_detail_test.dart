import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_ability.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_type.dart';

void main() {
  group('PokemonDetail Entity', () {
    const tStats = [
      PokemonStat(name: 'hp', baseStat: 35, effort: 0),
      PokemonStat(name: 'attack', baseStat: 55, effort: 0),
      PokemonStat(name: 'defense', baseStat: 40, effort: 0),
      PokemonStat(name: 'special-attack', baseStat: 50, effort: 0),
      PokemonStat(name: 'special-defense', baseStat: 50, effort: 0),
      PokemonStat(name: 'speed', baseStat: 90, effort: 2),
    ];

    const tAbilities = [
      PokemonAbility(name: 'static', isHidden: false, slot: 1),
      PokemonAbility(name: 'lightning-rod', isHidden: true, slot: 3),
    ];

    const tTypes = [
      PokemonType(name: 'electric', slot: 1),
    ];

    const tSprites = PokemonSprites(
      frontDefault:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
      frontShiny:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/25.png',
      officialArtwork:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
    );

    test(
      'GIVEN two PokemonDetail instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        const pokemon1 = PokemonDetail(
          id: 25,
          name: 'pikachu',
          types: tTypes,
          height: 4,
          weight: 60,
          baseExperience: 112,
          stats: tStats,
          abilities: tAbilities,
          sprites: tSprites,
        );

        const pokemon2 = PokemonDetail(
          id: 25,
          name: 'pikachu',
          types: tTypes,
          height: 4,
          weight: 60,
          baseExperience: 112,
          stats: tStats,
          abilities: tAbilities,
          sprites: tSprites,
        );

        expect(pokemon1, equals(pokemon2));
      },
    );

    test(
      'GIVEN a PokemonDetail instance '
      'WHEN accessing its properties '
      'THEN it should expose correct values',
      () {
        const pokemon = PokemonDetail(
          id: 25,
          name: 'pikachu',
          types: tTypes,
          height: 4,
          weight: 60,
          baseExperience: 112,
          stats: tStats,
          abilities: tAbilities,
          sprites: tSprites,
        );

        expect(pokemon.id, 25);
        expect(pokemon.name, 'pikachu');
        expect(pokemon.types, tTypes);
        expect(pokemon.height, 4);
        expect(pokemon.weight, 60);
        expect(pokemon.baseExperience, 112);
        expect(pokemon.stats, tStats);
        expect(pokemon.abilities, tAbilities);
        expect(pokemon.sprites, tSprites);
      },
    );
  });
}
