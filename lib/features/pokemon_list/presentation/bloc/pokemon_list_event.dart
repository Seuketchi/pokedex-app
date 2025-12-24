part of 'pokemon_list_bloc.dart';

@freezed
class PokemonListEvent with _$PokemonListEvent {
  const factory PokemonListEvent.fetch({
    @Default(20) int limit,
    @Default(0) int offset,
  }) = _Fetch;

  const factory PokemonListEvent.loadMore() = _LoadMore;

  const factory PokemonListEvent.getByType(String typeName) = _GetByType;

  const factory PokemonListEvent.search(String query) = _Search;

  const factory PokemonListEvent.fetchTypes() = _FetchTypes;
}
