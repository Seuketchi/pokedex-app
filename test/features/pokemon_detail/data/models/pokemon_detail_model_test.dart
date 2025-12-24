import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_detail_model.dart';

void main() {
  group('PokemonDetailModel', () {
    group('fromJson', () {
      test(
        'GIVEN valid JSON with all required fields '
        'WHEN PokemonDetailModel.fromJson is called '
        'THEN it should return a valid PokemonDetailModel',
        () {
          // Arrange
          final json = {
            'id': 1,
            'name': 'bulbasaur',
            'height': 7,
            'weight': 69,
            'base_experience': 64,
            'types': [
              {
                'slot': 1,
                'type': {'name': 'grass'},
              },
              {
                'slot': 2,
                'type': {'name': 'poison'},
              },
            ],
            'stats': [
              {
                'base_stat': 45,
                'effort': 0,
                'stat': {'name': 'hp'},
              },
              {
                'base_stat': 49,
                'effort': 0,
                'stat': {'name': 'attack'},
              },
            ],
            'abilities': [
              {
                'is_hidden': false,
                'slot': 1,
                'ability': {'name': 'overgrow'},
              },
              {
                'is_hidden': true,
                'slot': 3,
                'ability': {'name': 'chlorophyll'},
              },
            ],
            'sprites': {
              'front_default': 'https://example.com/front.png',
              'front_shiny': 'https://example.com/shiny.png',
              'back_default': 'https://example.com/back.png',
              'back_shiny': 'https://example.com/back-shiny.png',
            },
          };

          // Act
          final result = PokemonDetailModel.fromJson(json);

          // Assert
          expect(result.id, 1);
          expect(result.name, 'bulbasaur');
          expect(result.height, 7);
          expect(result.weight, 69);
          expect(result.baseExperience, 64);
          expect(result.types, hasLength(2));
          expect(result.types.first.type.name, 'grass');
          expect(result.stats, hasLength(2));
          expect(result.stats.first.baseStat, 45);
          expect(result.abilities, hasLength(2));
          expect(result.abilities.first.ability.name, 'overgrow');
          expect(result.sprites.frontDefault, 'https://example.com/front.png');
        },
      );

      test(
        'GIVEN JSON with nullable sprite fields '
        'WHEN PokemonDetailModel.fromJson is called '
        'THEN it should handle null values correctly',
        () {
          // Arrange
          final json = {
            'id': 1,
            'name': 'bulbasaur',
            'height': 7,
            'weight': 69,
            'base_experience': 64,
            'types': [
              {
                'slot': 1,
                'type': {'name': 'grass'},
              },
            ],
            'stats': [
              {
                'base_stat': 45,
                'effort': 0,
                'stat': {'name': 'hp'},
              },
            ],
            'abilities': [
              {
                'is_hidden': false,
                'slot': 1,
                'ability': {'name': 'overgrow'},
              },
            ],
            'sprites': {
              'front_default': 'https://example.com/front.png',
              'front_shiny': null,
              'back_default': null,
              'back_shiny': null,
            },
          };

          // Act
          final result = PokemonDetailModel.fromJson(json);

          // Assert
          expect(result.sprites.frontDefault, 'https://example.com/front.png');
          expect(result.sprites.frontShiny, isNull);
          expect(result.sprites.backDefault, isNull);
          expect(result.sprites.backShiny, isNull);
        },
      );
    });
  });
}
