import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_pokemon.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/calculate_damage.dart';

void main() {
  late CalculateDamage usecase;

  setUp(() {
    usecase = CalculateDamage();
  });

  const attacker = BattlePokemon(
    id: 1,
    name: 'pikachu',
    imageUrl: 'url',
    types: ['electric'],
    maxHp: 35,
    currentHp: 35,
    attack: 55,
    defense: 40,
    speed: 90,
    moves: [],
  );

  const defender = BattlePokemon(
    id: 2,
    name: 'charmander',
    imageUrl: 'url',
    types: ['fire'],
    maxHp: 39,
    currentHp: 39,
    attack: 52,
    defense: 43,
    speed: 65,
    moves: [],
  );

  const move = Move(
    id: 1,
    name: 'thunderbolt',
    power: 90,
    accuracy: 100,
    pp: 15,
    type: 'electric',
  );

  group('CalculateDamage UseCase', () {
    test(
      'GIVEN normal type effectiveness '
      'WHEN damage is calculated '
      'THEN it should return base damage',
      () async {
        const params = CalculateDamageParams(
          attacker: attacker,
          defender: defender,
          move: move,
          typeEffectiveness: 1,
        );

        final result = await usecase(params);

        result.when(
          (damage) {
            expect(damage, greaterThan(0));
            expect(damage, lessThan(100));
          },
          failure: (_) => fail('Should not fail'),
        );
      },
    );

    test(
      'GIVEN super effective hit (2x) '
      'WHEN damage is calculated '
      'THEN it should return double damage',
      () async {
        const normalParams = CalculateDamageParams(
          attacker: attacker,
          defender: defender,
          move: move,
          typeEffectiveness: 1,
        );

        const superEffectiveParams = CalculateDamageParams(
          attacker: attacker,
          defender: defender,
          move: move,
          typeEffectiveness: 2,
        );

        final normalResult = await usecase(normalParams);
        final superResult = await usecase(superEffectiveParams);

        int? normalDamage;
        int? superDamage;

        normalResult.when(
          (damage) => normalDamage = damage,
          failure: (_) => fail('Should not fail'),
        );

        superResult.when(
          (damage) => superDamage = damage,
          failure: (_) => fail('Should not fail'),
        );

        expect(superDamage, greaterThan(normalDamage!));
      },
    );

    test(
      'GIVEN not very effective hit (0.5x) '
      'WHEN damage is calculated '
      'THEN it should return half damage',
      () async {
        const params = CalculateDamageParams(
          attacker: attacker,
          defender: defender,
          move: move,
          typeEffectiveness: 0.5,
        );

        final result = await usecase(params);

        result.when(
          (damage) => expect(damage, greaterThan(0)),
          failure: (_) => fail('Should not fail'),
        );
      },
    );

    test(
      'GIVEN no effect (0x) '
      'WHEN damage is calculated '
      'THEN it should return minimum 1 damage',
      () async {
        const params = CalculateDamageParams(
          attacker: attacker,
          defender: defender,
          move: move,
          typeEffectiveness: 0,
        );

        final result = await usecase(params);

        result.when(
          (damage) => expect(damage, equals(1)),
          failure: (_) => fail('Should not fail'),
        );
      },
    );
  });
}
