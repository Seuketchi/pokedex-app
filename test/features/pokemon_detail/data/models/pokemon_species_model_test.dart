import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_species_model.dart';

void main() {
  group('PokemonSpeciesModel', () {
    group('fromJson', () {
      test(
        'GIVEN valid JSON with evolution_chain URL '
        'WHEN PokemonSpeciesModel.fromJson is called '
        'THEN it should convert URL to evolution chain ID',
        () {
          // Arrange
          final json = {
            'id': 1,
            'name': 'bulbasaur',
            'evolution_chain': {
              'url': 'https://pokeapi.co/api/v2/evolution-chain/1/',
            },
          };

          // Act
          final result = PokemonSpeciesModel.fromJson(json);

          // Assert
          expect(result.id, 1);
          expect(result.name, 'bulbasaur');
          expect(result.evolutionChain.id, 1);
        },
      );

      test(
        'GIVEN evolution_chain URL with different ID '
        'WHEN PokemonSpeciesModel.fromJson is called '
        'THEN it should extract the correct ID',
        () {
          // Arrange
          final json = {
            'id': 133,
            'name': 'eevee',
            'evolution_chain': {
              'url': 'https://pokeapi.co/api/v2/evolution-chain/67/',
            },
          };

          // Act
          final result = PokemonSpeciesModel.fromJson(json);

          // Assert
          expect(result.evolutionChain.id, 67);
        },
      );
    });
  });
}
