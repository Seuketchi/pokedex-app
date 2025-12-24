import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_node.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_ability.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_type.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/usecases/get_evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/usecases/get_pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/presentation/bloc/pokemon_detail_bloc.dart';

class MockGetPokemonDetail extends Mock implements GetPokemonDetail {}

class MockGetEvolutionChain extends Mock implements GetEvolutionChain {}

void main() {
  late MockGetPokemonDetail mockGetPokemonDetail;
  late MockGetEvolutionChain mockGetEvolutionChain;
  late PokemonDetailBloc bloc;

  setUp(() {
    mockGetPokemonDetail = MockGetPokemonDetail();
    mockGetEvolutionChain = MockGetEvolutionChain();
    bloc = PokemonDetailBloc(mockGetPokemonDetail, mockGetEvolutionChain);
  });

  setUpAll(() {
    registerFallbackValue(PokemonIdParams(id: 1));
    registerFallbackValue(SpeciesIdParams(speciesId: 1));
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

  final testEvolutionChain = EvolutionChain(
    id: 1,
    chain: EvolutionNode(
      speciesName: 'bulbasaur',
      speciesId: 1,
      trigger: null,
      minLevel: null,
      item: null,
      evolvesTo: [
        EvolutionNode(
          speciesName: 'ivysaur',
          speciesId: 2,
          trigger: 'level-up',
          minLevel: 16,
          item: null,
          evolvesTo: [],
        ),
      ],
    ),
  );

  group('PokemonDetailBloc', () {
    test(
      'GIVEN PokemonDetailBloc is created '
      'WHEN no events are added '
      'THEN initial state should be PokemonDetailState()',
      () {
        expect(bloc.state, const PokemonDetailState());
      },
    );

    group('LoadDetail', () {
      blocTest<PokemonDetailBloc, PokemonDetailState>(
        'GIVEN GetPokemonDetail returns success '
        'WHEN LoadDetail event is added '
        'THEN it should emit loading and success states',
        build: () {
          when(
            () => mockGetPokemonDetail(any()),
          ).thenAnswer((_) async => ResultSuccess(testPokemonDetail));
          return bloc;
        },
        act: (bloc) => bloc.add(const PokemonDetailEvent.loadDetail(1)),
        expect: () => [
          const PokemonDetailState(
            isLoadingDetail: true,
            detailErrorMessage: null,
          ),
          PokemonDetailState(
            isLoadingDetail: false,
            pokemonDetail: testPokemonDetail,
          ),
        ],
        verify: (_) {
          verify(() => mockGetPokemonDetail(PokemonIdParams(id: 1))).called(1);
        },
      );

      blocTest<PokemonDetailBloc, PokemonDetailState>(
        'GIVEN GetPokemonDetail returns failure '
        'WHEN LoadDetail event is added '
        'THEN it should emit loading and error states',
        build: () {
          when(() => mockGetPokemonDetail(any())).thenAnswer(
            (_) async => const Result.failure(
              ServerFailure(message: 'Server error'),
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const PokemonDetailEvent.loadDetail(1)),
        expect: () => [
          const PokemonDetailState(
            isLoadingDetail: true,
            detailErrorMessage: null,
          ),
          const PokemonDetailState(
            isLoadingDetail: false,
            detailErrorMessage: 'Server error',
          ),
        ],
        verify: (_) {
          verify(() => mockGetPokemonDetail(PokemonIdParams(id: 1))).called(1);
        },
      );
    });

    group('LoadEvolution', () {
      blocTest<PokemonDetailBloc, PokemonDetailState>(
        'GIVEN GetEvolutionChain returns success '
        'WHEN LoadEvolution event is added '
        'THEN it should emit loading and success states',
        build: () {
          when(
            () => mockGetEvolutionChain(any()),
          ).thenAnswer((_) async => ResultSuccess(testEvolutionChain));
          return bloc;
        },
        act: (bloc) => bloc.add(const PokemonDetailEvent.loadEvolution(1)),
        expect: () => [
          const PokemonDetailState(
            isLoadingEvolution: true,
            evolutionErrorMessage: null,
          ),
          PokemonDetailState(
            isLoadingEvolution: false,
            evolutionChain: testEvolutionChain,
          ),
        ],
        verify: (_) {
          verify(
            () => mockGetEvolutionChain(SpeciesIdParams(speciesId: 1)),
          ).called(1);
        },
      );

      blocTest<PokemonDetailBloc, PokemonDetailState>(
        'GIVEN GetEvolutionChain returns failure '
        'WHEN LoadEvolution event is added '
        'THEN it should emit loading and error states',
        build: () {
          when(() => mockGetEvolutionChain(any())).thenAnswer(
            (_) async => const Result.failure(
              NetworkFailure(message: 'No internet'),
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const PokemonDetailEvent.loadEvolution(1)),
        expect: () => [
          const PokemonDetailState(
            isLoadingEvolution: true,
            evolutionErrorMessage: null,
          ),
          const PokemonDetailState(
            isLoadingEvolution: false,
            evolutionErrorMessage: 'No internet',
          ),
        ],
        verify: (_) {
          verify(
            () => mockGetEvolutionChain(SpeciesIdParams(speciesId: 1)),
          ).called(1);
        },
      );
    });

    group('Independent Loading', () {
      blocTest<PokemonDetailBloc, PokemonDetailState>(
        'GIVEN both events are triggered '
        'WHEN they complete independently '
        'THEN state should have both data without conflicts',
        build: () {
          when(
            () => mockGetPokemonDetail(any()),
          ).thenAnswer((_) async => ResultSuccess(testPokemonDetail));
          when(
            () => mockGetEvolutionChain(any()),
          ).thenAnswer((_) async => ResultSuccess(testEvolutionChain));
          return bloc;
        },
        act: (bloc) {
          bloc.add(const PokemonDetailEvent.loadDetail(1));
          bloc.add(const PokemonDetailEvent.loadEvolution(1));
        },
        expect: () => [
          const PokemonDetailState(
            isLoadingDetail: true,
            detailErrorMessage: null,
          ),
          PokemonDetailState(
            isLoadingDetail: false,
            pokemonDetail: testPokemonDetail,
          ),
          PokemonDetailState(
            isLoadingEvolution: true,
            evolutionErrorMessage: null,
            pokemonDetail: testPokemonDetail,
          ),
          PokemonDetailState(
            isLoadingEvolution: false,
            pokemonDetail: testPokemonDetail,
            evolutionChain: testEvolutionChain,
          ),
        ],
      );
    });
  });
}
