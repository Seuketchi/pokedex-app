import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_list_response.dart';

void main() {
  group('PokemonListResponse', () {
    group('fromJson', () {
      test(
        'GIVEN valid JSON with results list '
        'WHEN PokemonListResponse.fromJson is called '
        'THEN it should return a PokemonListResponse with parsed PokemonModel list',
        () {
          // Arrange
          final json = {
            'results': [
              {
                'name': 'bulbasaur',
                'url': 'https://pokeapi.co/api/v2/pokemon/1/',
              },
              {
                'name': 'ivysaur',
                'url': 'https://pokeapi.co/api/v2/pokemon/2/',
              },
            ],
          };

          // Act
          final result = PokemonListResponse.fromJson(json);

          // Assert
          expect(result.results.length, 2);
          expect(result.results.first.name, 'bulbasaur');
          expect(
            result.results.first.imageUrl,
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
          );
          expect(result.results.last.name, 'ivysaur');
        },
      );
    });
  });
}
