import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_node.dart';

void main() {
  group('EvolutionChain Entity', () {
    test(
      'GIVEN two EvolutionChain instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        // Arrange
        const node = EvolutionNode(
          speciesName: 'bulbasaur',
          speciesId: 1,
          trigger: null,
          minLevel: null,
          item: null,
          evolvesTo: [],
        );

        const chain1 = EvolutionChain(
          id: 1,
          chain: node,
        );

        const chain2 = EvolutionChain(
          id: 1,
          chain: node,
        );

        // Act & Assert
        expect(chain1, equals(chain2));
      },
    );

    test(
      'GIVEN two EvolutionChain instances with different values '
      'WHEN they are compared '
      'THEN they should not be equal',
      () {
        // Arrange
        const node1 = EvolutionNode(
          speciesName: 'bulbasaur',
          speciesId: 1,
          trigger: null,
          minLevel: null,
          item: null,
          evolvesTo: [],
        );

        const node2 = EvolutionNode(
          speciesName: 'charmander',
          speciesId: 4,
          trigger: null,
          minLevel: null,
          item: null,
          evolvesTo: [],
        );

        const chain1 = EvolutionChain(
          id: 1,
          chain: node1,
        );

        const chain2 = EvolutionChain(
          id: 2,
          chain: node2,
        );

        // Act & Assert
        expect(chain1, isNot(equals(chain2)));
      },
    );

    test(
      'GIVEN an EvolutionChain instance '
      'WHEN accessing its properties '
      'THEN it should expose correct values',
      () {
        // Arrange
        const node = EvolutionNode(
          speciesName: 'eevee',
          speciesId: 133,
          trigger: null,
          minLevel: null,
          item: null,
          evolvesTo: [],
        );

        const chain = EvolutionChain(
          id: 67,
          chain: node,
        );

        // Act & Assert
        expect(chain.id, 67);
        expect(chain.chain.speciesName, 'eevee');
        expect(chain.chain.speciesId, 133);
      },
    );
  });
}
