import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/evolution_chain_model.dart';

void main() {
  group('EvolutionChainModel', () {
    group('fromJson', () {
      test(
        'GIVEN valid JSON with linear evolution chain '
        'WHEN EvolutionChainModel.fromJson is called '
        'THEN it should return a valid EvolutionChainModel with URL converted to ID',
        () {
          // Arrange
          final json = {
            'id': 1,
            'chain': {
              'species': {
                'name': 'bulbasaur',
                'url': 'https://pokeapi.co/api/v2/pokemon-species/1/',
              },
              'evolution_details': [],
              'evolves_to': [
                {
                  'species': {
                    'name': 'ivysaur',
                    'url': 'https://pokeapi.co/api/v2/pokemon-species/2/',
                  },
                  'evolution_details': [
                    {
                      'min_level': 16,
                      'trigger': {'name': 'level-up'},
                      'item': null,
                    },
                  ],
                  'evolves_to': [
                    {
                      'species': {
                        'name': 'venusaur',
                        'url': 'https://pokeapi.co/api/v2/pokemon-species/3/',
                      },
                      'evolution_details': [
                        {
                          'min_level': 32,
                          'trigger': {'name': 'level-up'},
                          'item': null,
                        },
                      ],
                      'evolves_to': [],
                    },
                  ],
                },
              ],
            },
          };

          // Act
          final result = EvolutionChainModel.fromJson(json);

          // Assert
          expect(result.id, 1);
          expect(result.chain.species.name, 'bulbasaur');
          expect(result.chain.species.id, 1);
          expect(result.chain.evolvesTo, hasLength(1));
          expect(result.chain.evolvesTo.first.species.name, 'ivysaur');
          expect(result.chain.evolvesTo.first.species.id, 2);
          expect(
            result.chain.evolvesTo.first.evolutionDetails.first.minLevel,
            16,
          );
          expect(result.chain.evolvesTo.first.evolvesTo, hasLength(1));
          expect(
            result.chain.evolvesTo.first.evolvesTo.first.species.name,
            'venusaur',
          );
          expect(result.chain.evolvesTo.first.evolvesTo.first.species.id, 3);
        },
      );

      test(
        'GIVEN valid JSON with branching evolution (Eevee) '
        'WHEN EvolutionChainModel.fromJson is called '
        'THEN it should handle multiple evolution paths',
        () {
          // Arrange
          final json = {
            'id': 67,
            'chain': {
              'species': {
                'name': 'eevee',
                'url': 'https://pokeapi.co/api/v2/pokemon-species/133/',
              },
              'evolution_details': [],
              'evolves_to': [
                {
                  'species': {
                    'name': 'vaporeon',
                    'url': 'https://pokeapi.co/api/v2/pokemon-species/134/',
                  },
                  'evolution_details': [
                    {
                      'min_level': null,
                      'trigger': {'name': 'use-item'},
                      'item': {'name': 'water-stone'},
                    },
                  ],
                  'evolves_to': [],
                },
                {
                  'species': {
                    'name': 'jolteon',
                    'url': 'https://pokeapi.co/api/v2/pokemon-species/135/',
                  },
                  'evolution_details': [
                    {
                      'min_level': null,
                      'trigger': {'name': 'use-item'},
                      'item': {'name': 'thunder-stone'},
                    },
                  ],
                  'evolves_to': [],
                },
                {
                  'species': {
                    'name': 'flareon',
                    'url': 'https://pokeapi.co/api/v2/pokemon-species/136/',
                  },
                  'evolution_details': [
                    {
                      'min_level': null,
                      'trigger': {'name': 'use-item'},
                      'item': {'name': 'fire-stone'},
                    },
                  ],
                  'evolves_to': [],
                },
              ],
            },
          };

          // Act
          final result = EvolutionChainModel.fromJson(json);

          // Assert
          expect(result.id, 67);
          expect(result.chain.species.name, 'eevee');
          expect(result.chain.species.id, 133);
          expect(result.chain.evolvesTo, hasLength(3));
          expect(result.chain.evolvesTo[0].species.name, 'vaporeon');
          expect(result.chain.evolvesTo[0].species.id, 134);
          expect(
            result.chain.evolvesTo[0].evolutionDetails.first.item?.name,
            'water-stone',
          );
          expect(result.chain.evolvesTo[1].species.name, 'jolteon');
          expect(result.chain.evolvesTo[1].species.id, 135);
          expect(result.chain.evolvesTo[2].species.name, 'flareon');
          expect(result.chain.evolvesTo[2].species.id, 136);
        },
      );

      test(
        'GIVEN JSON with empty evolution_details '
        'WHEN EvolutionChainModel.fromJson is called '
        'THEN it should handle base Pokemon without evolution requirements',
        () {
          // Arrange
          final json = {
            'id': 1,
            'chain': {
              'species': {
                'name': 'bulbasaur',
                'url': 'https://pokeapi.co/api/v2/pokemon-species/1/',
              },
              'evolution_details': [],
              'evolves_to': [],
            },
          };

          // Act
          final result = EvolutionChainModel.fromJson(json);

          // Assert
          expect(result.chain.species.name, 'bulbasaur');
          expect(result.chain.evolutionDetails, isEmpty);
          expect(result.chain.evolvesTo, isEmpty);
        },
      );
    });
  });
}
