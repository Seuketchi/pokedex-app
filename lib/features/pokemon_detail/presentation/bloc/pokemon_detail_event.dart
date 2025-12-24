part of 'pokemon_detail_bloc.dart';

@freezed
class PokemonDetailEvent with _$PokemonDetailEvent {
  const factory PokemonDetailEvent.loadDetail(int id) = _LoadDetail;

  const factory PokemonDetailEvent.loadEvolution(int speciesId) =
      _LoadEvolution;
}
