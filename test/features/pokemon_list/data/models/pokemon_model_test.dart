import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_model.dart';

void main() {
  group('PokemonModel', () {
    group('fromJson', () {
      test(
        'GIVEN valid JSON with name and url '
        'WHEN PokemonModel.fromJson is called '
        'THEN it should return a valid PokemonModel with converted imageUrl',
        () {
          // Arrange
          final json = {
            'name': 'bulbasaur',
            'url': 'https://pokeapi.co/api/v2/pokemon/1/',
          };

          // Act
          final result = PokemonModel.fromJson(json);

          // Assert
          expect(result.name, 'bulbasaur');
          expect(
            result.imageUrl,
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
          );
        },
      );
    });
  });
}
