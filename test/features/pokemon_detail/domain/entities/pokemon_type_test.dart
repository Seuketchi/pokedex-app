import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_type.dart';

void main() {
  group('PokemonType Entity', () {
    test(
      'GIVEN two PokemonType instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        const type1 = PokemonType(name: 'fire', slot: 1);
        const type2 = PokemonType(name: 'fire', slot: 1);

        expect(type1, equals(type2));
      },
    );

    test(
      'GIVEN two PokemonType instances with different values '
      'WHEN they are compared '
      'THEN they should not be equal',
      () {
        const type1 = PokemonType(name: 'fire', slot: 1);
        const type2 = PokemonType(name: 'water', slot: 2);

        expect(type1, isNot(equals(type2)));
      },
    );

    test(
      'GIVEN a PokemonType instance '
      'WHEN accessing its properties '
      'THEN they should return correct values',
      () {
        const type = PokemonType(name: 'electric', slot: 1);

        expect(type.name, 'electric');
        expect(type.slot, 1);
      },
    );

    test(
      'GIVEN a PokemonType with slot 2 '
      'WHEN accessing its properties '
      'THEN it should expose secondary type slot',
      () {
        const type = PokemonType(name: 'poison', slot: 2);

        expect(type.slot, 2);
      },
    );
  });
}
