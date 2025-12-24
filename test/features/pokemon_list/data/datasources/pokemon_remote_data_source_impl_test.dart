import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:pokedex_app/features/pokemon_list/data/datasources/pokemon_api_service.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_list_response.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_type_response.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late PokemonApiService apiService;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    apiService = PokemonApiService(dio);
  });

  group('PokemonApiService', () {
    test(
      'GIVEN API returns pokemon list '
      'WHEN getPokemonList is called '
      'THEN it should return PokemonListResponse',
      () async {
        // Arrange
        const limit = 20;
        const offset = 0;

        dioAdapter.onGet(
          '/pokemon',
          (server) => server.reply(
            200,
            {
              'results': [
                {
                  'name': 'bulbasaur',
                  'url': 'https://pokeapi.co/api/v2/pokemon/1/',
                },
              ],
            },
          ),
          queryParameters: {'limit': limit, 'offset': offset},
        );

        // Act
        final result = await apiService.getPokemonList(limit, offset);

        // Assert
        expect(result, isA<PokemonListResponse>());
        expect(result.results.length, 1);
        expect(result.results.first.name, 'bulbasaur');
      },
    );

    test(
      'GIVEN API returns pokemon by type '
      'WHEN getPokemonByType is called '
      'THEN it should return PokemonTypeResponse',
      () async {
        // Arrange
        const typeName = 'fire';

        dioAdapter.onGet(
          '/type/$typeName',
          (server) => server.reply(
            200,
            {
              'pokemon': [
                {
                  'pokemon': {
                    'name': 'charmander',
                    'url': 'https://pokeapi.co/api/v2/pokemon/4/',
                  },
                },
              ],
            },
          ),
        );

        // Act
        final result = await apiService.getPokemonByType(typeName);

        // Assert
        expect(result, isA<PokemonTypeResponse>());
        expect(result.pokemon.length, 1);
        expect(result.pokemon.first.pokemon.name, 'charmander');
      },
    );

    test(
      'GIVEN API returns pokemon search result '
      'WHEN searchPokemon is called '
      'THEN it should return PokemonListResponse',
      () async {
        // Arrange
        const query = 'pikachu';

        dioAdapter.onGet(
          '/pokemon/$query',
          (server) => server.reply(
            200,
            {
              'results': [
                {
                  'name': 'pikachu',
                  'url': 'https://pokeapi.co/api/v2/pokemon/25/',
                },
              ],
            },
          ),
        );

        // Act
        final result = await apiService.searchPokemon(query);

        // Assert
        expect(result, isA<PokemonListResponse>());
        expect(result.results.length, 1);
        expect(result.results.first.name, 'pikachu');
      },
    );
  });
}
