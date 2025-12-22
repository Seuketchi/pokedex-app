import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/local/hive_constants.dart';

abstract class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();
    await _openBoxes();
  }

  static Future<void> _openBoxes() async {
    await Future.wait([
      Hive.openBox<String>(HiveBoxes.pokemonList),
      Hive.openBox<String>(HiveBoxes.pokemonDetail),
      Hive.openBox<String>(HiveBoxes.settings),
      Hive.openBox<int>(HiveBoxes.favorites),
    ]);
  }

  static Future<void> close() async {
    await Hive.close();
  }

  static Future<void> clearAll() async {
    await Future.wait([
      Hive.box<String>(HiveBoxes.pokemonList).clear(),
      Hive.box<String>(HiveBoxes.pokemonDetail).clear(),
      Hive.box<int>(HiveBoxes.favorites).clear(),
    ]);
  }
}

@module
abstract class HiveModule {
  // Store JSON Strings of cached Pokemon list responses
  @lazySingleton
  Box<String> get pokemonListBox => Hive.box<String>(HiveBoxes.pokemonList);

  // Stores JSON Strings of cached Pokemon detail responses
  @lazySingleton
  Box<String> get pokemonDetailBox => Hive.box<String>(HiveBoxes.pokemonDetail);

  // Stores user preferences
  @lazySingleton
  Box<dynamic> get settingsBox => Hive.box<dynamic>(HiveBoxes.settings);

  // Stores favorite pokemon ids
  @lazySingleton
  Box<int> get favoriteBox => Hive.box<int>(HiveBoxes.favorites);
}
