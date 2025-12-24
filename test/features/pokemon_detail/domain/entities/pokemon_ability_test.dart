import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_ability.dart';

void main() {
  group('PokemonAbility Entity', () {
    test(
      'GIVEN two PokemonAbility instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        // Arrange
        const ability1 = PokemonAbility(
          name: 'overgrow',
          isHidden: false,
          slot: 1,
        );

        const ability2 = PokemonAbility(
          name: 'overgrow',
          isHidden: false,
          slot: 1,
        );

        // Act & Assert
        expect(ability1, equals(ability2));
      },
    );

    test(
      'GIVEN two PokemonAbility instances with different values '
      'WHEN they are compared '
      'THEN they should not be equal',
      () {
        // Arrange
        const ability1 = PokemonAbility(
          name: 'overgrow',
          isHidden: false,
          slot: 1,
        );

        const ability2 = PokemonAbility(
          name: 'chlorophyll',
          isHidden: true,
          slot: 3,
        );

        // Act & Assert
        expect(ability1, isNot(equals(ability2)));
      },
    );

    test(
      'GIVEN a PokemonAbility instance '
      'WHEN accessing its properties '
      'THEN it should expose correct values',
      () {
        // Arrange
        const ability = PokemonAbility(
          name: 'beast-boost',
          isHidden: true,
          slot: 3,
        );

        // Act & Assert
        expect(ability.name, 'beast-boost');
        expect(ability.isHidden, true);
        expect(ability.slot, 3);
      },
    );
  });
}
