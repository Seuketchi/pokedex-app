import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/type.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon_list/domain/usecases/get_pokemon_types.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late MockPokemonRepository mockRepository;
  late GetPokemonTypes usecase;

  setUp(() {
    mockRepository = MockPokemonRepository();
    usecase = GetPokemonTypes(mockRepository);
  });

  final testTypes = [
    const Type(id: 1, name: 'normal'),
    const Type(id: 2, name: 'fighting'),
    const Type(id: 3, name: 'flying'),
  ];

  group('GetPokemonTypes UseCase', () {
    test(
      'GIVEN repository returns types list '
      'WHEN usecase is called with NoParams '
      'THEN it should return the list from repository',
      () async {
        // Arrange
        when(
          () => mockRepository.getPokemonTypes(),
        ).thenAnswer((_) async => ResultSuccess(testTypes));

        // Act
        final result = await usecase(const NoParams());

        // Assert
        expect(result, ResultSuccess(testTypes));
        verify(() => mockRepository.getPokemonTypes()).called(1);
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

        when(() => mockRepository.getPokemonTypes()).thenAnswer(
          (_) async => const Result.failure(failure),
        );

        // Act
        final result = await usecase(const NoParams());

        // Assert
        expect(
          result,
          const Result<List<Type>, Failure>.failure(failure),
        );
        verify(() => mockRepository.getPokemonTypes()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
