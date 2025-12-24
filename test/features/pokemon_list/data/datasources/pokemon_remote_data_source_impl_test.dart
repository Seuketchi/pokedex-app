import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/pokemon_list/data/datasources/pokemon_api_service.dart';
import 'package:pokedex_app/features/pokemon_list/data/datasources/pokemon_remote_data_source_impl.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_list_response.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_model.dart';

class MockPokemonApiService extends Mock implements PokemonApiService {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late PokemonRemoteDataSourceImpl dataSource;
  late MockPokemonApiService mockApiService;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockApiService = MockPokemonApiService();
    mockNetworkInfo = MockNetworkInfo();
    dataSource = PokemonRemoteDataSourceImpl(mockApiService, mockNetworkInfo);
  });

  group('getPokemonList', () {
    const tLimit = 20;
    const tOffset = 0;
    final tPokemonModels = [
      const PokemonModel(name: 'bulbasaur', imageUrl: 'url1'),
      const PokemonModel(name: 'ivysaur', imageUrl: 'url2'),
    ];
    final tPokemonListResponse = PokemonListResponse(results: tPokemonModels);

    test(
      'GIVEN network is connected '
      'WHEN getPokemonList is called '
      'THEN should return list of PokemonModel from API',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockApiService.getPokemonList(tLimit, tOffset),
        ).thenAnswer((_) async => tPokemonListResponse);

        // Act
        final result = await dataSource.getPokemonList(
          limit: tLimit,
          offset: tOffset,
        );

        // Assert
        expect(result, equals(tPokemonModels));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.getPokemonList(tLimit, tOffset)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN network is not connected '
      'WHEN getPokemonList is called '
      'THEN should throw NetworkException',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final call = dataSource.getPokemonList;

        // Assert
        expect(
          () => call(limit: tLimit, offset: tOffset),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.message,
              'message',
              'No internet connection',
            ),
          ),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN API service throws DioException '
      'WHEN getPokemonList is called '
      'THEN should throw ServerException',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockApiService.getPokemonList(tLimit, tOffset)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'Server error',
          ),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.getPokemonList(limit: tLimit, offset: tOffset),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Server error',
            ),
          ),
        );

        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.getPokemonList(tLimit, tOffset)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN API service throws DioException without message '
      'WHEN getPokemonList is called '
      'THEN should throw ServerException with default message',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockApiService.getPokemonList(tLimit, tOffset)).thenThrow(
          DioException(requestOptions: RequestOptions(path: '')),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.getPokemonList(limit: tLimit, offset: tOffset),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Failed to fetch Pokémon list',
            ),
          ),
        );

        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.getPokemonList(tLimit, tOffset)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );
  });

  group('getPokemonByType', () {
    const tTypeName = 'fire';
    final tPokemonModels = [
      const PokemonModel(name: 'charmander', imageUrl: 'url4'),
      const PokemonModel(name: 'charmeleon', imageUrl: 'url5'),
    ];
    final tPokemonListResponse = PokemonListResponse(results: tPokemonModels);

    test(
      'GIVEN network is connected '
      'WHEN getPokemonByType is called '
      'THEN should return list of PokemonModel from API',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockApiService.getPokemonByType(tTypeName),
        ).thenAnswer((_) async => tPokemonListResponse);

        // Act
        final result = await dataSource.getPokemonByType(tTypeName);

        // Assert
        expect(result, equals(tPokemonModels));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.getPokemonByType(tTypeName)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN network is not connected '
      'WHEN getPokemonByType is called '
      'THEN should throw NetworkException',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final call = dataSource.getPokemonByType;

        // Assert
        expect(
          () => call(tTypeName),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.message,
              'message',
              'No internet connection',
            ),
          ),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN API service throws DioException '
      'WHEN getPokemonByType is called '
      'THEN should throw ServerException',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockApiService.getPokemonByType(tTypeName)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'Type not found',
          ),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.getPokemonByType(tTypeName),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Type not found',
            ),
          ),
        );

        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.getPokemonByType(tTypeName)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN API service throws DioException without message '
      'WHEN getPokemonByType is called '
      'THEN should throw ServerException with default message',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockApiService.getPokemonByType(tTypeName)).thenThrow(
          DioException(requestOptions: RequestOptions(path: '')),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.getPokemonByType(tTypeName),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Failed to fetch Pokémon by type',
            ),
          ),
        );

        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.getPokemonByType(tTypeName)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );
  });

  group('searchPokemon', () {
    const tQuery = 'Pikachu';
    const tQueryLowercase = 'pikachu';
    final tPokemonModels = [
      const PokemonModel(name: 'pikachu', imageUrl: 'url25'),
    ];
    final tSearchResponse = PokemonListResponse(results: tPokemonModels);

    test(
      'GIVEN network is connected and query exists '
      'WHEN searchPokemon is called '
      'THEN should return list of PokemonModel with lowercase query',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockApiService.searchPokemon(tQueryLowercase),
        ).thenAnswer((_) async => tSearchResponse);

        // Act
        final result = await dataSource.searchPokemon(tQuery);

        // Assert
        expect(result, equals(tPokemonModels));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.searchPokemon(tQueryLowercase)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN network is not connected '
      'WHEN searchPokemon is called '
      'THEN should throw NetworkException',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final call = dataSource.searchPokemon;

        // Assert
        expect(
          () => call(tQuery),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.message,
              'message',
              'No internet connection',
            ),
          ),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN API service throws DioException with 404 status '
      'WHEN searchPokemon is called '
      'THEN should return empty list',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockApiService.searchPokemon(tQueryLowercase)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
            ),
          ),
        );

        // Act
        final result = await dataSource.searchPokemon(tQuery);

        // Assert
        expect(result, equals(<PokemonModel>[]));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.searchPokemon(tQueryLowercase)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN API service throws DioException with non-404 status '
      'WHEN searchPokemon is called '
      'THEN should throw ServerException',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockApiService.searchPokemon(tQueryLowercase)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500,
            ),
            message: 'Internal server error',
          ),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.searchPokemon(tQuery),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Internal server error',
            ),
          ),
        );

        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.searchPokemon(tQueryLowercase)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );

    test(
      'GIVEN API service throws DioException without message '
      'WHEN searchPokemon is called '
      'THEN should throw ServerException with default message',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockApiService.searchPokemon(tQueryLowercase)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500,
            ),
          ),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.searchPokemon(tQuery),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Failed to search Pokémon',
            ),
          ),
        );

        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockApiService.searchPokemon(tQueryLowercase)).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockApiService);
      },
    );
  });
}
