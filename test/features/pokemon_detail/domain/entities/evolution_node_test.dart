import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_node.dart';

void main() {
  group('EvolutionNode Entity', () {
    test(
      'GIVEN two EvolutionNode instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
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
          speciesName: 'bulbasaur',
          speciesId: 1,
          trigger: null,
          minLevel: null,
          item: null,
          evolvesTo: [],
        );

        // Act & Assert
        expect(node1, equals(node2));
      },
    );

    test(
      'GIVEN two EvolutionNode instances with different values '
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
          speciesName: 'ivysaur',
          speciesId: 2,
          trigger: 'level-up',
          minLevel: 16,
          item: null,
          evolvesTo: [],
        );

        // Act & Assert
        expect(node1, isNot(equals(node2)));
      },
    );

    test(
      'GIVEN an EvolutionNode instance '
      'WHEN accessing its properties '
      'THEN it should expose correct values',
      () {
        // Arrange
        const node = EvolutionNode(
          speciesName: 'vaporeon',
          speciesId: 134,
          trigger: 'use-item',
          minLevel: null,
          item: 'water-stone',
          evolvesTo: [],
        );

        // Act & Assert
        expect(node.speciesName, 'vaporeon');
        expect(node.speciesId, 134);
        expect(node.trigger, 'use-item');
        expect(node.minLevel, null);
        expect(node.item, 'water-stone');
        expect(node.evolvesTo, isEmpty);
      },
    );

    test(
      'GIVEN an EvolutionNode with nested evolutions '
      'WHEN accessing the recursive structure '
      'THEN it should maintain the evolution chain',
      () {
        // Arrange
        const venusaur = EvolutionNode(
          speciesName: 'venusaur',
          speciesId: 3,
          trigger: 'level-up',
          minLevel: 32,
          item: null,
          evolvesTo: [],
        );

        const ivysaur = EvolutionNode(
          speciesName: 'ivysaur',
          speciesId: 2,
          trigger: 'level-up',
          minLevel: 16,
          item: null,
          evolvesTo: [venusaur],
        );

        const bulbasaur = EvolutionNode(
          speciesName: 'bulbasaur',
          speciesId: 1,
          trigger: null,
          minLevel: null,
          item: null,
          evolvesTo: [ivysaur],
        );

        // Act & Assert
        expect(bulbasaur.evolvesTo, hasLength(1));
        expect(bulbasaur.evolvesTo.first.speciesName, 'ivysaur');
        expect(bulbasaur.evolvesTo.first.evolvesTo, hasLength(1));
        expect(
          bulbasaur.evolvesTo.first.evolvesTo.first.speciesName,
          'venusaur',
        );
      },
    );
  });
}
