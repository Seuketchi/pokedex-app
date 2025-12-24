import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon_list/domain/usecases/filter_by_type.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late MockPokemonRepository mockRepository;
  late FilterByType usecase;

  setUp(() {
    mockRepository = MockPokemonRepository();
    usecase = FilterByType(mockRepository);
  });

  final testPokemonList = [
    const Pokemon(
      name: 'charmander',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
    ),
  ];

  group('FilterByType UseCase', () {
    test(
      'GIVEN repository returns Pokemon list '
      'WHEN usecase is called '
      'THEN it should return the list from repository',
      () async {
        // Arrange
        const type = 'fire';

        when(
          () => mockRepository.filterByType(type),
        ).thenAnswer(
          (_) async => ResultSuccess(testPokemonList),
        );

        // Act
        final result = await usecase(type);

        // Assert
        expect(result, ResultSuccess(testPokemonList));
        verify(() => mockRepository.filterByType(type)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'GIVEN repository returns ServerFailure '
      'WHEN usecase is called '
      'THEN it should return the failure',
      () async {
        // Arrange
        const type = 'fire';
        const failure = ServerFailure(message: 'Server error');

        when(
          () => mockRepository.filterByType(type),
        ).thenAnswer(
          (_) async => const Result.failure(failure),
        );

        // Act
        final result = await usecase(type);

        // Assert
        expect(
          result,
          const Result<List<Pokemon>, Failure>.failure(failure),
        );
        verify(() => mockRepository.filterByType(type)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
