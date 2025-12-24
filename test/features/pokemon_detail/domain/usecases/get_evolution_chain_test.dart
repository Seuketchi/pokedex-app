import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_node.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/repositories/pokemon_detail_repository.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/usecases/get_evolution_chain.dart';

class MockPokemonDetailRepository extends Mock
    implements PokemonDetailRepository {}

void main() {
  late MockPokemonDetailRepository mockRepository;
  late GetEvolutionChain usecase;

  setUp(() {
    mockRepository = MockPokemonDetailRepository();
    usecase = GetEvolutionChain(mockRepository);
  });

  const testEvolutionChain = EvolutionChain(
    id: 1,
    chain: EvolutionNode(
      speciesName: 'bulbasaur',
      speciesId: 1,
      evolvesTo: [
        EvolutionNode(
          speciesName: 'ivysaur',
          speciesId: 2,
          trigger: 'level-up',
          minLevel: 16,
          evolvesTo: [],
        ),
      ],
    ),
  );

  group('GetEvolutionChain UseCase', () {
    test(
      'GIVEN repository returns EvolutionChain '
      'WHEN usecase is called with SpeciesIdParams '
      'THEN it should return the chain from repository',
      () async {
        // Arrange
        final params = SpeciesIdParams(speciesId: 1);

        when(
          () => mockRepository.getEvolutionChain(params.speciesId),
        ).thenAnswer(
          (_) async => const ResultSuccess(testEvolutionChain),
        );

        // Act
        final result = await usecase(params);

        // Assert
        expect(result, const ResultSuccess(testEvolutionChain));
        verify(
          () => mockRepository.getEvolutionChain(params.speciesId),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'GIVEN repository returns ServerFailure '
      'WHEN usecase is called '
      'THEN it should return the failure',
      () async {
        // Arrange
        const failure = ServerFailure(message: 'Server error');
        final params = SpeciesIdParams(speciesId: 1);

        when(
          () => mockRepository.getEvolutionChain(params.speciesId),
        ).thenAnswer(
          (_) async => const Result.failure(failure),
        );

        // Act
        final result = await usecase(params);

        // Assert
        expect(
          result,
          const Result<EvolutionChain, Failure>.failure(failure),
        );
        verify(
          () => mockRepository.getEvolutionChain(params.speciesId),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
