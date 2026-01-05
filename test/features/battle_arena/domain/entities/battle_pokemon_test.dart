import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_pokemon.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';

void main() {
  group('BattlePokemon Entity', () {
    test(
      'GIVEN two BattlePokemon instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        const pokemon1 = BattlePokemon(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'https://example.com/1.png',
          types: ['grass', 'poison'],
          maxHp: 45,
          currentHp: 45,
          attack: 49,
          defense: 49,
          speed: 45,
          moves: [],
        );

        const pokemon2 = BattlePokemon(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'https://example.com/1.png',
          types: ['grass', 'poison'],
          maxHp: 45,
          currentHp: 45,
          attack: 49,
          defense: 49,
          speed: 45,
          moves: [],
        );

        expect(pokemon1, equals(pokemon2));
      },
    );

    test(
      'GIVEN a BattlePokemon instance '
      'WHEN accessing its properties '
      'THEN it should expose correct values',
      () {
        const move = Move(
          id: 1,
          name: 'tackle',
          power: 40,
          accuracy: 100,
          pp: 35,
          type: 'normal',
        );

        const pokemon = BattlePokemon(
          id: 25,
          name: 'pikachu',
          imageUrl: 'https://example.com/25.png',
          types: ['electric'],
          maxHp: 35,
          currentHp: 20,
          attack: 55,
          defense: 40,
          speed: 90,
          moves: [move],
        );

        expect(pokemon.id, 25);
        expect(pokemon.name, 'pikachu');
        expect(pokemon.types, ['electric']);
        expect(pokemon.currentHp, 20);
        expect(pokemon.maxHp, 35);
        expect(pokemon.moves, hasLength(1));
      },
    );
  });
}
