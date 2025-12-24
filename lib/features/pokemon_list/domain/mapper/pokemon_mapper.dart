// features/pokemon_list/data/mappers/pokemon_mapper.dart
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';

extension PokemonMapper on PokemonModel {
  Pokemon toDomain() {
    return Pokemon(
      // id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }
}

extension PokemonModelMapper on Pokemon {
  PokemonModel toModel() {
    return PokemonModel(
      // id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }
}
