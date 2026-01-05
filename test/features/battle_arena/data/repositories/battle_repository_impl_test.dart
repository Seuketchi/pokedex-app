import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/battle_arena/data/datasources/battle_remote_data_source.dart';
import 'package:pokedex_app/features/battle_arena/data/models/move_model.dart';
import 'package:pokedex_app/features/battle_arena/data/models/type_effectiveness_model.dart';
import 'package:pokedex_app/features/battle_arena/data/repositories/battle_repository_impl.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/type_effectiveness.dart';

class MockBattleRemoteDataSource extends Mock
    implements BattleRemoteDataSource {}

void main() {
  late BattleRepositoryImpl repository;
  late MockBattleRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockBattleRemoteDataSource();
    repository = BattleRepositoryImpl(mockRemoteDataSource);
  });

  group('BattleRepositoryImpl', () {
    const tPokemonId = 1;
    const tTypeName = 'fire';

    final tMoveModels = [
      const MoveModel(
        id: 1,
        name: 'tackle',
        power: 40,
        accuracy: 100,
        pp: 35,
        type: MoveTypeModel(name: 'normal'),
      ),
      const MoveModel(
        id: 2,
        name: 'thunder-shock',
        power: 40,
        accuracy: 100,
        pp: 30,
        type: MoveTypeModel(name: 'electric'),
      ),
    ];

    const tTypeEffectivenessModel = TypeEffectivenessModel(
      name: 'fire',
      damageRelations: DamageRelationsModel(
        doubleDamageTo: [
          TypeNameModel(name: 'grass'),
          TypeNameModel(name: 'ice'),
        ],
        halfDamageTo: [
          TypeNameModel(name: 'water'),
          TypeNameModel(name: 'rock'),
        ],
        noDamageTo: <TypeNameModel>[],
      ),
    );

    group('getPokemonMoves', () {
      test(
        'should return list of moves when data source call is successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getPokemonMoves(tPokemonId),
          ).thenAnswer((_) async => tMoveModels);

          // act
          final result = await repository.getPokemonMoves(tPokemonId);

          // assert
          expect(result, isA<ResultSuccess<List<Move>, Failure>>());
          final moves = (result as ResultSuccess<List<Move>, Failure>).value;
          expect(moves, hasLength(2));
          expect(moves.first.name, equals('tackle'));
          expect(moves.first.power, equals(40));
          expect(moves.last.name, equals('thunder-shock'));
          verify(() => mockRemoteDataSource.getPokemonMoves(tPokemonId));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return NetworkFailure when NetworkException is thrown',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getPokemonMoves(tPokemonId),
          ).thenThrow(const NetworkException());

          // act
          final result = await repository.getPokemonMoves(tPokemonId);

          // assert
          expect(result, isA<ResultFailure<List<Move>, Failure>>());
          final failure =
              (result as ResultFailure<List<Move>, Failure>).failure;
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals('No internet connection'));
        },
      );

      test(
        'should return ServerFailure when ServerException is thrown',
        () async {
          // arrange
          const tErrorMessage = 'Server error occurred';
          when(
            () => mockRemoteDataSource.getPokemonMoves(tPokemonId),
          ).thenThrow(const ServerException(message: tErrorMessage));

          // act
          final result = await repository.getPokemonMoves(tPokemonId);

          // assert
          expect(result, isA<ResultFailure<List<Move>, Failure>>());
          final failure =
              (result as ResultFailure<List<Move>, Failure>).failure;
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals(tErrorMessage));
        },
      );

      test(
        'should return ServerFailure when unexpected Exception is thrown',
        () async {
          // arrange
          const tErrorMessage = 'Unexpected error';
          when(
            () => mockRemoteDataSource.getPokemonMoves(tPokemonId),
          ).thenThrow(Exception(tErrorMessage));

          // act
          final result = await repository.getPokemonMoves(tPokemonId);

          // assert
          expect(result, isA<ResultFailure<List<Move>, Failure>>());
          final failure =
              (result as ResultFailure<List<Move>, Failure>).failure;
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains(tErrorMessage));
        },
      );

      test('should filter out null moves from domain mapping', () async {
        // arrange
        final tMixedMoveModels = [
          const MoveModel(
            id: 1,
            name: 'tackle',
            power: 40,
            accuracy: 100,
            pp: 35,
            type: MoveTypeModel(name: 'normal'),
          ),
          const MoveModel(
            id: 2,
            name: 'status-move',
            power: null,
            accuracy: 100,
            pp: 30,
            type: MoveTypeModel(name: 'normal'),
          ),
        ];

        when(
          () => mockRemoteDataSource.getPokemonMoves(tPokemonId),
        ).thenAnswer((_) async => tMixedMoveModels);

        // act
        final result = await repository.getPokemonMoves(tPokemonId);

        // assert
        expect(result, isA<ResultSuccess<List<Move>, Failure>>());
        final moves = (result as ResultSuccess<List<Move>, Failure>).value;
        expect(moves.every((Move move) => move.power > 0), isTrue);
      });
    });

    group('getTypeEffectiveness', () {
      test(
        'should return type effectiveness when data source call is successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getTypeEffectiveness(tTypeName),
          ).thenAnswer((_) async => tTypeEffectivenessModel);

          // act
          final result = await repository.getTypeEffectiveness(tTypeName);

          // assert
          expect(result, isA<ResultSuccess<TypeEffectiveness, Failure>>());
          final effectiveness =
              (result as ResultSuccess<TypeEffectiveness, Failure>).value;
          expect(effectiveness.doubleDamageTo, contains('grass'));
          expect(effectiveness.halfDamageTo, contains('water'));
          verify(() => mockRemoteDataSource.getTypeEffectiveness(tTypeName));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return NetworkFailure when NetworkException is thrown',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getTypeEffectiveness(tTypeName),
          ).thenThrow(const NetworkException());

          // act
          final result = await repository.getTypeEffectiveness(tTypeName);

          // assert
          expect(result, isA<ResultFailure<TypeEffectiveness, Failure>>());
          final failure =
              (result as ResultFailure<TypeEffectiveness, Failure>).failure;
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals('No internet connection'));
        },
      );

      test(
        'should return ServerFailure when ServerException is thrown',
        () async {
          // arrange
          const tErrorMessage = 'Type not found';
          when(
            () => mockRemoteDataSource.getTypeEffectiveness(tTypeName),
          ).thenThrow(const ServerException(message: tErrorMessage));

          // act
          final result = await repository.getTypeEffectiveness(tTypeName);

          // assert
          expect(result, isA<ResultFailure<TypeEffectiveness, Failure>>());
          final failure =
              (result as ResultFailure<TypeEffectiveness, Failure>).failure;
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals(tErrorMessage));
        },
      );

      test(
        'should return ServerFailure when unexpected Exception is thrown',
        () async {
          // arrange
          const tErrorMessage = 'Unexpected error';
          when(
            () => mockRemoteDataSource.getTypeEffectiveness(tTypeName),
          ).thenThrow(Exception(tErrorMessage));

          // act
          final result = await repository.getTypeEffectiveness(tTypeName);

          // assert
          expect(result, isA<ResultFailure<TypeEffectiveness, Failure>>());
          final failure =
              (result as ResultFailure<TypeEffectiveness, Failure>).failure;
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains(tErrorMessage));
        },
      );
    });
  });
}
