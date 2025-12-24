import 'package:pokedex_app/features/pokemon_list/data/models/type_model.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/type.dart';

extension TypeMapper on TypeModel {
  Type toDomain() {
    return Type(
      id: id,
      name: name,
    );
  }
}
