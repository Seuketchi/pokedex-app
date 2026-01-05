import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';

void main() {
  group('Move Entity', () {
    test(
      'GIVEN two Move instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        const move1 = Move(
          id: 1,
          name: 'tackle',
          power: 40,
          accuracy: 100,
          pp: 35,
          type: 'normal',
        );

        const move2 = Move(
          id: 1,
          name: 'tackle',
          power: 40,
          accuracy: 100,
          pp: 35,
          type: 'normal',
        );

        expect(move1, equals(move2));
      },
    );

    test(
      'GIVEN a Move instance '
      'WHEN accessing its properties '
      'THEN it should expose correct values',
      () {
        const move = Move(
          id: 52,
          name: 'ember',
          power: 40,
          accuracy: 100,
          pp: 25,
          type: 'fire',
        );

        expect(move.id, 52);
        expect(move.name, 'ember');
        expect(move.power, 40);
        expect(move.accuracy, 100);
        expect(move.pp, 25);
        expect(move.type, 'fire');
      },
    );
  });
}
