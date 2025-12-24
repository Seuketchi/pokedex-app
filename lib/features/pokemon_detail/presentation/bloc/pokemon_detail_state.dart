part of 'pokemon_detail_bloc.dart';

@freezed
class PokemonDetailState with _$PokemonDetailState {
  const factory PokemonDetailState({
    @Default(false) bool isLoadingDetail,
    @Default(false) bool isLoadingEvolution,
    PokemonDetail? pokemonDetail,
    EvolutionChain? evolutionChain,
    String? detailErrorMessage,
    String? evolutionErrorMessage,
  }) = _PokemonDetailState;
}
