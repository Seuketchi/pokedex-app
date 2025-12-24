import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/features/pokemon_list/data/datasources/pokemon_api_service.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @singleton
  PokemonApiService providePokemonApiService(Dio dio) {
    return PokemonApiService(dio);
  }
}
