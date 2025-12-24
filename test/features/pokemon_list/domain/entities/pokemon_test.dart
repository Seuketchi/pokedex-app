import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';

void main() {
  group('Pokemon Entity', () {
    test(
      'GIVEN two Pokemon instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        // Arrange
        const pokemon1 = Pokemon(
          name: 'pikachu',
          imageUrl:
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        );

        const pokemon2 = Pokemon(
          name: 'pikachu',
          imageUrl:
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        );

        // Act & Assert
        expect(pokemon1, pokemon2);
      },
    );

    test(
      'GIVEN a Pokemon instance '
      'WHEN copyWith is called with a new name '
      'THEN it should return a new instance with updated value',
      () {
        // Arrange
        const pokemon = Pokemon(
          name: 'pikachu',
          imageUrl:
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        );

        // Act
        final updatedPokemon = pokemon.copyWith(name: 'raichu');

        // Assert
        expect(updatedPokemon.name, 'raichu');
        expect(updatedPokemon.imageUrl, pokemon.imageUrl);
        expect(updatedPokemon, isNot(pokemon));
      },
    );
  });
}
