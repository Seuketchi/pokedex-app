import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/type_effectiveness.dart';
import 'package:pokedex_app/features/battle_arena/domain/repositories/battle_repository.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/get_type_effectiveness.dart';

class MockBattleRepository extends Mock implements BattleRepository {}

void main() {
  late MockBattleRepository mockRepository;
  late GetTypeEffectiveness usecase;

  setUp(() {
    mockRepository = MockBattleRepository();
    usecase = GetTypeEffectiveness(mockRepository);
  });

  const testTypeEffectiveness = TypeEffectiveness(
    typeName: 'fire',
    doubleDamageTo: ['grass', 'ice', 'bug', 'steel'],
    halfDamageTo: ['fire', 'water', 'rock', 'dragon'],
    noDamageTo: [],
  );

  group('GetTypeEffectiveness UseCase', () {
    test(
      'GIVEN repository returns type effectiveness '
      'WHEN usecase is called with TypeEffectivenessParams '
      'THEN it should return the effectiveness from repository',
      () async {
        when(
          () => mockRepository.getTypeEffectiveness('fire'),
        ).thenAnswer((_) async => const ResultSuccess(testTypeEffectiveness));

        final result = await usecase(
          const TypeEffectivenessParams(typeName: 'fire'),
        );

        expect(result, const ResultSuccess(testTypeEffectiveness));
        verify(() => mockRepository.getTypeEffectiveness('fire')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'GIVEN repository returns ServerFailure '
      'WHEN usecase is called '
      'THEN it should return the failure',
      () async {
        const failure = ServerFailure(message: 'Server error');

        when(() => mockRepository.getTypeEffectiveness('fire')).thenAnswer(
          (_) async => const Result.failure(failure),
        );

        final result = await usecase(
          const TypeEffectivenessParams(typeName: 'fire'),
        );

        expect(
          result,
          const Result<TypeEffectiveness, Failure>.failure(failure),
        );
        verify(() => mockRepository.getTypeEffectiveness('fire')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
