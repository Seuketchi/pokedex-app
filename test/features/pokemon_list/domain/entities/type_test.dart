import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/type.dart';

void main() {
  group('Type Entity', () {
    test(
      'GIVEN two Type instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        // Arrange
        const type1 = Type(id: 1, name: 'fire');
        const type2 = Type(id: 1, name: 'fire');

        // Act & Assert
        expect(type1, equals(type2));
      },
    );

    test(
      'GIVEN two Type instances with different values '
      'WHEN they are compared '
      'THEN they should not be equal',
      () {
        // Arrange
        const type1 = Type(id: 1, name: 'fire');
        const type2 = Type(id: 2, name: 'water');

        // Act & Assert
        expect(type1, isNot(equals(type2)));
      },
    );

    test(
      'GIVEN a Type instance '
      'WHEN accessing its properties '
      'THEN it should expose correct values',
      () {
        // Arrange
        const type = Type(id: 10, name: 'fire');

        // Act & Assert
        expect(type.id, 10);
        expect(type.name, 'fire');
      },
    );
  });
}
