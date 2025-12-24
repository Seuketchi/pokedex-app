import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_type_response.dart';

void main() {
  group('PokemonTypeResponse', () {
    group('fromJson', () {
      test(
        'GIVEN valid JSON with pokemon list '
        'WHEN PokemonTypeResponse.fromJson is called '
        'THEN it should return a PokemonTypeResponse with parsed '
        'PokemonTypeSlot list',
        () {
          // Arrange
          final json = {
            'pokemon': [
              {
                'pokemon': {
                  'name': 'bulbasaur',
                  'url': 'https://pokeapi.co/api/v2/pokemon/1/',
                },
              },
              {
                'pokemon': {
                  'name': 'ivysaur',
                  'url': 'https://pokeapi.co/api/v2/pokemon/2/',
                },
              },
            ],
          };

          // Act
          final result = PokemonTypeResponse.fromJson(json);

          // Assert
          expect(result.pokemon.length, 2);
          expect(result.pokemon.first.pokemon.name, 'bulbasaur');
          expect(
            result.pokemon.first.pokemon.imageUrl,
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/'
            'sprites/pokemon/1.png',
          );
          expect(result.pokemon.last.pokemon.name, 'ivysaur');
          expect(
            result.pokemon.last.pokemon.imageUrl,
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/'
            'sprites/pokemon/2.png',
          );
        },
      );

      test(
        'GIVEN valid JSON with empty pokemon list '
        'WHEN PokemonTypeResponse.fromJson is called '
        'THEN it should return a PokemonTypeResponse with empty list',
        () {
          // Arrange
          final json = {
            'pokemon': <Map<String, dynamic>>[],
          };

          // Act
          final result = PokemonTypeResponse.fromJson(json);

          // Assert
          expect(result.pokemon, isEmpty);
        },
      );
    });
  });

  group('PokemonTypeSlot', () {
    group('fromJson', () {
      test(
        'GIVEN valid JSON with pokemon data '
        'WHEN PokemonTypeSlot.fromJson is called '
        'THEN it should return a PokemonTypeSlot with parsed PokemonModel',
        () {
          // Arrange
          final json = {
            'pokemon': {
              'name': 'charmander',
              'url': 'https://pokeapi.co/api/v2/pokemon/4/',
            },
          };

          // Act
          final result = PokemonTypeSlot.fromJson(json);

          // Assert
          expect(result.pokemon.name, 'charmander');
          expect(
            result.pokemon.imageUrl,
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/'
            'sprites/pokemon/4.png',
          );
        },
      );
    });
  });
}
