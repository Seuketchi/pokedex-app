import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/converter/url_id_converter.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/battle_arena/data/datasources/battle_api_service.dart';
import 'package:pokedex_app/features/battle_arena/data/datasources/battle_remote_data_source.dart';
import 'package:pokedex_app/features/battle_arena/data/models/move_model.dart';
import 'package:pokedex_app/features/battle_arena/data/models/type_effectiveness_model.dart';

@Singleton(as: BattleRemoteDataSource)
class BattleRemoteDataSourceImpl implements BattleRemoteDataSource {
  BattleRemoteDataSourceImpl(this.apiService, this.networkInfo);

  final BattleApiService apiService;
  final NetworkInfo networkInfo;
  final _urlConverter = const UrlIdConverter();

  @override
  Future<List<MoveModel>> getPokemonMoves(int pokemonId) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      // Step 1: Get Pokemon's move list
      final pokemonResponse = await apiService.getPokemonMoves(pokemonId);
      final moves = <MoveModel>[];

      // Step 2: Fetch moves in batches (parallel) until we have 4
      final moveSlots = pokemonResponse.moves.toList();

      // Process in batches of 8 moves at a time
      for (var i = 0; i < moveSlots.length && moves.length < 4; i += 8) {
        final batch = moveSlots.skip(i).take(8).toList();

        // Fetch this batch in parallel
        final batchFutures = batch.map((slot) {
          return _fetchMoveIfValid(slot.move.url);
        }).toList();

        final batchResults = await Future.wait(batchFutures);

        // Add valid attacking moves
        for (final move in batchResults) {
          if (move != null && moves.length < 4) {
            moves.add(move);
          }
        }
      }

      // If we still don't have 4 moves, that's okay, return what we have
      return moves;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch Pokemon moves',
      );
    }
  }

  Future<MoveModel?> _fetchMoveIfValid(String url) async {
    try {
      final moveId = _urlConverter.fromJson(url);
      final move = await apiService.getMove(moveId);
      return move; // Return all moves, filtering happens in mapper
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  Future<TypeEffectivenessModel> getTypeEffectiveness(String typeName) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      return await apiService.getTypeEffectiveness(typeName.toLowerCase());
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch type effectiveness',
      );
    }
  }
}
