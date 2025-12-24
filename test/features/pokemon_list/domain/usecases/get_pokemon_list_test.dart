import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/pokemon_list/domain/usecases/get_pokemon_list.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late MockPokemonRepository mockRepository;
  late GetPokemonList usecase;

  setUp(() {
    mockRepository = MockPokemonRepository();
    usecase = GetPokemonList(mockRepository);
  });

  final testPokemonList = [
    const Pokemon(
      name: 'bulbasaur',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    ),
  ];

  group('GetPokemonList UseCase', () {
    test(
      'GIVEN repository returns Pokemon list '
      'WHEN usecase is called with PaginationParams '
      'THEN it should return the list from repository',
      () async {
        // Arrange
        const params = PaginationParams();

        when(
          () => mockRepository.getPokemonList(
            limit: params.limit,
            offset: params.offset,
          ),
        ).thenAnswer(
          (_) async => ResultSuccess(testPokemonList),
        );

        // Act
        final result = await usecase(params);

        // Assert
        expect(result, ResultSuccess(testPokemonList));
        verify(
          () => mockRepository.getPokemonList(
            limit: params.limit,
            offset: params.offset,
          ),
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

        const params = PaginationParams();

        when(
          () => mockRepository.getPokemonList(
            limit: params.limit,
            offset: params.offset,
          ),
        ).thenAnswer(
          (_) async => const Result.failure(failure),
        );

        // Act
        final result = await usecase(params);

        // Assert
        expect(
          result,
          const Result<List<Pokemon>, Failure>.failure(failure),
        );
        verify(
          () => mockRepository.getPokemonList(
            limit: params.limit,
            offset: params.offset,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
