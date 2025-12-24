part of 'pokemon_list_bloc.dart';

@freezed
class PokemonListState with _$PokemonListState {
  const factory PokemonListState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default([]) List<Pokemon> pokemons,
    @Default(0) int currentOffset,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _PokemonListState;
}
