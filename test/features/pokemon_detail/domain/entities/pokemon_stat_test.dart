import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_stat.dart';

void main() {
  group('PokemonStat Entity', () {
    test(
      'GIVEN two PokemonStat instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        const stat1 = PokemonStat(
          name: 'hp',
          baseStat: 45,
          effort: 0,
        );

        const stat2 = PokemonStat(
          name: 'hp',
          baseStat: 45,
          effort: 0,
        );

        expect(stat1, equals(stat2));
      },
    );

    test(
      'GIVEN two PokemonStat instances with different values '
      'WHEN they are compared '
      'THEN they should not be equal',
      () {
        const stat1 = PokemonStat(
          name: 'hp',
          baseStat: 45,
          effort: 0,
        );

        const stat2 = PokemonStat(
          name: 'attack',
          baseStat: 55,
          effort: 1,
        );

        expect(stat1, isNot(equals(stat2)));
      },
    );

    test(
      'GIVEN a PokemonStat instance '
      'WHEN accessing its properties '
      'THEN they should return correct values',
      () {
        const stat = PokemonStat(
          name: 'special-attack',
          baseStat: 65,
          effort: 1,
        );

        expect(stat.name, 'special-attack');
        expect(stat.baseStat, 65);
        expect(stat.effort, 1);
      },
    );
  });
}
