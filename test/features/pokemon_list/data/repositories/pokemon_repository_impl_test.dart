import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_list/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon_list/data/repositories/pokemon_repository_impl.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';

class MockPokemonRemoteDataSource extends Mock
    implements PokemonRemoteDataSource {}

void main() {
  late MockPokemonRemoteDataSource mockRemoteDataSource;
  late PokemonRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockPokemonRemoteDataSource();
    repository = PokemonRepositoryImpl(mockRemoteDataSource);
  });

  final testPokemonModel = PokemonModel.fromJson({
    'name': 'bulbasaur',
    'url': 'https://pokeapi.co/api/v2/pokemon/1/',
  });

  final testPokemonListModel = [testPokemonModel];

  const testPokemonEntity = Pokemon(
    name: 'bulbasaur',
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
  );

  final testPokemonListEntity = [testPokemonEntity];

  group('getPokemonList', () {
    test(
      'GIVEN remote data source returns PokemonModel list '
      'WHEN getPokemonList is called '
      'THEN it should return ResultSuccess with Pokemon entities',
      () async {
        when(
          () => mockRemoteDataSource.getPokemonList(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => testPokemonListModel);

        final result = await repository.getPokemonList(limit: 20, offset: 0);

        expect(result, ResultSuccess(testPokemonListEntity));
        verify(
          () => mockRemoteDataSource.getPokemonList(),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'GIVEN remote data source throws NetworkException '
      'WHEN getPokemonList is called '
      'THEN it should return Result.failure with NetworkFailure',
      () async {
        when(
          () => mockRemoteDataSource.getPokemonList(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenThrow(const NetworkException());

        final result = await repository.getPokemonList(limit: 20, offset: 0);

        expect(
          result,
          const Result<List<Pokemon>, Failure>.failure(
            NetworkFailure(),
          ),
        );
        verify(
          () => mockRemoteDataSource.getPokemonList(),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'GIVEN remote data source throws ServerException '
      'WHEN getPokemonList is called '
      'THEN it should return Result.failure with ServerFailure',
      () async {
        when(
          () => mockRemoteDataSource.getPokemonList(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenThrow(const ServerException(message: 'Server error'));

        final result = await repository.getPokemonList(limit: 20, offset: 0);

        expect(
          result,
          const Result<List<Pokemon>, Failure>.failure(
            ServerFailure(message: 'Server error'),
          ),
        );
        verify(
          () => mockRemoteDataSource.getPokemonList(),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('filterByType', () {
    test(
      'GIVEN remote data source returns PokemonModel list '
      'WHEN filterByType is called '
      'THEN it should return ResultSuccess with Pokemon entities',
      () async {
        const type = 'grass';
        when(
          () => mockRemoteDataSource.getPokemonByType(type),
        ).thenAnswer((_) async => testPokemonListModel);

        final result = await repository.filterByType(type);

        expect(result, ResultSuccess(testPokemonListEntity));
        verify(() => mockRemoteDataSource.getPokemonByType(type)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('searchPokemon', () {
    test(
      'GIVEN remote data source returns PokemonModel list '
      'WHEN searchPokemon is called '
      'THEN it should return ResultSuccess with Pokemon entities',
      () async {
        const query = 'bulbasaur';
        when(
          () => mockRemoteDataSource.searchPokemon(query),
        ).thenAnswer((_) async => testPokemonListModel);

        final result = await repository.searchPokemon(query);

        expect(result, ResultSuccess(testPokemonListEntity));
        verify(() => mockRemoteDataSource.searchPokemon(query)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
