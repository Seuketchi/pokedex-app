import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';
import 'package:pokedex_app/features/battle_arena/domain/repositories/battle_repository.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/get_pokemon_moves.dart';

class MockBattleRepository extends Mock implements BattleRepository {}

void main() {
  late MockBattleRepository mockRepository;
  late GetPokemonMoves usecase;

  setUp(() {
    mockRepository = MockBattleRepository();
    usecase = GetPokemonMoves(mockRepository);
  });

  final testMoves = [
    const Move(
      id: 1,
      name: 'tackle',
      power: 40,
      accuracy: 100,
      pp: 35,
      type: 'normal',
    ),
    const Move(
      id: 52,
      name: 'ember',
      power: 40,
      accuracy: 100,
      pp: 25,
      type: 'fire',
    ),
  ];

  group('GetPokemonMoves UseCase', () {
    test(
      'GIVEN repository returns moves list '
      'WHEN usecase is called with PokemonMovesParams '
      'THEN it should return the list from repository',
      () async {
        when(
          () => mockRepository.getPokemonMoves(1),
        ).thenAnswer((_) async => ResultSuccess(testMoves));

        final result = await usecase(const PokemonMovesParams(pokemonId: 1));

        expect(result, ResultSuccess(testMoves));
        verify(() => mockRepository.getPokemonMoves(1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'GIVEN repository returns ServerFailure '
      'WHEN usecase is called '
      'THEN it should return the failure',
      () async {
        const failure = ServerFailure(message: 'Server error');

        when(() => mockRepository.getPokemonMoves(1)).thenAnswer(
          (_) async => const Result.failure(failure),
        );

        final result = await usecase(const PokemonMovesParams(pokemonId: 1));

        expect(
          result,
          const Result<List<Move>, Failure>.failure(failure),
        );
        verify(() => mockRepository.getPokemonMoves(1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
