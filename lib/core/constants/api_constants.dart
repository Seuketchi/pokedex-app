abstract class ApiConstants {
  // base URL
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  // endpoints
  // Get list of Pokemon: /pokemon?limit=20&offset=0
  static const String pokemon = '/pokemon';

  // Get Pokemon by ID or name: /pokemon/{id}
  static String pokemonById(int id) => '/pokemon/$id';

  static String pokemonByName(String name) => '/pokemon/$name';

  // Get Pokemon species (for evolution chain URL): /pokemon-species/{id}
  static String pokemonSpecies(int id) => '/pokemon-species/$id';

  // Get evolution chain: /evolution-chain/{id}
  static String evolutionChain(int id) => '/evolution-chain/$id';

  // Get type info: /type/{id}
  static String type(int id) => '/type/$id';

  static String typeByName(String name) => '/type/$name';

  // Get move info: /move/{id}
  static String move(int id) => '/move/$id';

  // Get ability info: /ability/{id}
  static String ability(int id) => '/ability/$id';

  // timeouts
  // Connection timeout in milliseconds
  static const int connectTimeout = 30000; // 30 seconds

  // Receive timeout in milliseconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Send timeout in milliseconds
  static const int sendTimeout = 30000; // 30 seconds

  // pagination

  /// Default number of items per page
  static const int defaultLimit = 20;

  /// Maximum items per page (PokéAPI allows up to 100)
  static const int maxLimit = 100;

  /// First generation Pokemon count (for MVP)
  static const int firstGenCount = 151;
}
