import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_pokemon.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/calculate_damage.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/get_pokemon_moves.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/get_type_effectiveness.dart';
import 'package:pokedex_app/features/battle_arena/presentation/bloc/battle_bloc.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_ability.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_sprites.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_stat.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_type.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/usecases/get_pokemon_detail.dart';

class MockGetPokemonDetail extends Mock implements GetPokemonDetail {}

class MockGetPokemonMoves extends Mock implements GetPokemonMoves {}

class MockGetTypeEffectiveness extends Mock implements GetTypeEffectiveness {}

class MockCalculateDamage extends Mock implements CalculateDamage {}

void main() {
  late MockGetPokemonDetail mockGetPokemonDetail;
  late MockGetPokemonMoves mockGetPokemonMoves;
  late MockGetTypeEffectiveness mockGetTypeEffectiveness;
  late MockCalculateDamage mockCalculateDamage;
  late BattleBloc bloc;

  setUp(() {
    mockGetPokemonDetail = MockGetPokemonDetail();
    mockGetPokemonMoves = MockGetPokemonMoves();
    mockGetTypeEffectiveness = MockGetTypeEffectiveness();
    mockCalculateDamage = MockCalculateDamage();
    bloc = BattleBloc(
      mockGetPokemonDetail,
      mockGetPokemonMoves,
      mockGetTypeEffectiveness,
      mockCalculateDamage,
    );
  });

  setUpAll(() {
    registerFallbackValue(const PokemonIdParams(id: 1));
    registerFallbackValue(const PokemonMovesParams(pokemonId: 1));
    registerFallbackValue(const TypeEffectivenessParams(typeName: 'fire'));
    registerFallbackValue(
      const CalculateDamageParams(
        attacker: BattlePokemon(
          id: 1,
          name: 'test',
          imageUrl: 'url',
          types: [],
          maxHp: 100,
          currentHp: 100,
          attack: 50,
          defense: 50,
          speed: 50,
          moves: [],
        ),
        defender: BattlePokemon(
          id: 2,
          name: 'test2',
          imageUrl: 'url',
          types: [],
          maxHp: 100,
          currentHp: 100,
          attack: 50,
          defense: 50,
          speed: 50,
          moves: [],
        ),
        move: Move(
          id: 1,
          name: 'tackle',
          power: 40,
          accuracy: 100,
          pp: 35,
          type: 'normal',
        ),
        typeEffectiveness: 1,
      ),
    );
  });

  const testPokemonDetail = PokemonDetail(
    id: 1,
    name: 'pikachu',
    types: [PokemonType(name: 'electric', slot: 1)],
    height: 4,
    weight: 60,
    baseExperience: 112,
    stats: [
      PokemonStat(name: 'hp', baseStat: 35, effort: 0),
      PokemonStat(name: 'attack', baseStat: 55, effort: 0),
      PokemonStat(name: 'defense', baseStat: 40, effort: 0),
      PokemonStat(name: 'speed', baseStat: 90, effort: 0),
    ],
    abilities: [PokemonAbility(name: 'static', isHidden: false, slot: 1)],
    sprites: PokemonSprites(frontDefault: 'url'),
  );

  final testMoves = [
    const Move(
      id: 1,
      name: 'thunderbolt',
      power: 90,
      accuracy: 100,
      pp: 15,
      type: 'electric',
    ),
  ];

  group('BattleBloc', () {
    test('initial state is BattleState()', () {
      expect(bloc.state, const BattleState());
    });

    blocTest<BattleBloc, BattleState>(
      'GIVEN successful Pokemon data fetch '
      'WHEN InitializeBattle event is added '
      'THEN it should emit initialized state',
      build: () {
        when(
          () => mockGetPokemonDetail(any()),
        ).thenAnswer((_) async => const ResultSuccess(testPokemonDetail));
        when(
          () => mockGetPokemonMoves(any()),
        ).thenAnswer((_) async => ResultSuccess(testMoves));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const BattleEvent.initializeBattle(
          playerPokemonId: 1,
          opponentPokemonId: 1,
        ),
      ),
      expect: () => [
        const BattleState(isLoading: true),
        predicate<BattleState>(
          (state) =>
              !state.isLoading &&
              state.isInitialized &&
              state.playerPokemon != null &&
              state.opponentPokemon != null,
        ),
      ],
    );
  });
}
