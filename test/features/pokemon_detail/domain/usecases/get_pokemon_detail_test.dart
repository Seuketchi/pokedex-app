import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_ability.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_type.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/repositories/pokemon_detail_repository.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/usecases/get_pokemon_detail.dart';

class MockPokemonDetailRepository extends Mock
    implements PokemonDetailRepository {}

void main() {
  late MockPokemonDetailRepository mockRepository;
  late GetPokemonDetail usecase;

  setUp(() {
    mockRepository = MockPokemonDetailRepository();
    usecase = GetPokemonDetail(mockRepository);
  });

  final testPokemonDetail = PokemonDetail(
    id: 1,
    name: 'bulbasaur',
    types: const [
      PokemonType(name: 'grass', slot: 1),
      PokemonType(name: 'poison', slot: 2),
    ],
    height: 7,
    weight: 69,
    baseExperience: 64,
    stats: const [
      PokemonStat(name: 'hp', baseStat: 45, effort: 0),
      PokemonStat(name: 'attack', baseStat: 49, effort: 0),
    ],
    abilities: const [
      PokemonAbility(name: 'overgrow', isHidden: false, slot: 1),
    ],
    sprites: const PokemonSprites(
      frontDefault: 'https://example.com/1.png',
      frontShiny: 'https://example.com/1-shiny.png',
      backDefault: null,
      backShiny: null,
    ),
  );

  group('GetPokemonDetail UseCase', () {
    test(
      'GIVEN repository returns PokemonDetail '
      'WHEN usecase is called with PokemonIdParams '
      'THEN it should return the detail from repository',
      () async {
        // Arrange
        final params = PokemonIdParams(id: 1);

        when(
          () => mockRepository.getPokemonDetail(params.id),
        ).thenAnswer(
          (_) async => ResultSuccess(testPokemonDetail),
        );

        // Act
        final result = await usecase(params);

        // Assert
        expect(result, ResultSuccess(testPokemonDetail));
        verify(
          () => mockRepository.getPokemonDetail(params.id),
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
        final params = PokemonIdParams(id: 1);

        when(
          () => mockRepository.getPokemonDetail(params.id),
        ).thenAnswer(
          (_) async => const Result.failure(failure),
        );

        // Act
        final result = await usecase(params);

        // Assert
        expect(
          result,
          const Result<PokemonDetail, Failure>.failure(failure),
        );
        verify(
          () => mockRepository.getPokemonDetail(params.id),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
