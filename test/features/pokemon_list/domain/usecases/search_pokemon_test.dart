import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon_list/domain/usecases/search_pokemon.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late MockPokemonRepository mockRepository;
  late SearchPokemon usecase;

  setUp(() {
    mockRepository = MockPokemonRepository();
    usecase = SearchPokemon(mockRepository);
  });

  final testPokemonList = [
    const Pokemon(
      name: 'pikachu',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
    ),
  ];

  group('SearchPokemon UseCase', () {
    test(
      'GIVEN repository returns Pokemon list '
      'WHEN usecase is called '
      'THEN it should return the list from repository',
      () async {
        // Arrange
        const query = 'pikachu';

        when(
          () => mockRepository.searchPokemon(query),
        ).thenAnswer(
          (_) async => ResultSuccess(testPokemonList),
        );

        // Act
        final result = await usecase(query);

        // Assert
        expect(result, ResultSuccess(testPokemonList));
        verify(() => mockRepository.searchPokemon(query)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'GIVEN repository returns ServerFailure '
      'WHEN usecase is called '
      'THEN it should return the failure',
      () async {
        // Arrange
        const query = 'pikachu';
        const failure = ServerFailure(message: 'Server error');

        when(
          () => mockRepository.searchPokemon(query),
        ).thenAnswer(
          (_) async => const Result.failure(failure),
        );

        // Act
        final result = await usecase(query);

        // Assert
        expect(
          result,
          const Result<List<Pokemon>, Failure>.failure(failure),
        );
        verify(() => mockRepository.searchPokemon(query)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
