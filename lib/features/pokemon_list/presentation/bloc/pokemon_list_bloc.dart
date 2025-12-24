import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/type.dart';
import 'package:pokedex_app/features/pokemon_list/domain/usecases/filter_by_type.dart';
import 'package:pokedex_app/features/pokemon_list/domain/usecases/get_pokemon_list.dart';
import 'package:pokedex_app/features/pokemon_list/domain/usecases/get_pokemon_types.dart';
import 'package:pokedex_app/features/pokemon_list/domain/usecases/search_pokemon.dart';

part 'pokemon_list_bloc.freezed.dart';
part 'pokemon_list_event.dart';
part 'pokemon_list_state.dart';

@injectable
class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  PokemonListBloc(
    this.getPokemonList,
    this.getPokemonByType,
    this.searchPokemon,
    this.getPokemonTypes,
  ) : super(const PokemonListState()) {
    on<_Fetch>(_onFetch);
    on<_LoadMore>(_onLoadMore);
    on<_GetByType>(_onGetByType);
    on<_Search>(_onSearch);
    on<_FetchTypes>(_onFetchTypes);
  }

  final GetPokemonList getPokemonList;
  final FilterByType getPokemonByType;
  final SearchPokemon searchPokemon;
  final GetPokemonTypes getPokemonTypes;
  static const _limit = 20;
  List<Pokemon> _allPokemon = [];

  Future<void> _onFetch(
    _Fetch event,
    Emitter<PokemonListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (_allPokemon.isEmpty) {
      final allResult = await getPokemonList(
        PaginationParams(limit: 1000, offset: 0),
      );
      allResult.when(
        (pokemons) => _allPokemon = pokemons,
        failure: (_) => _allPokemon = [],
      );
    }

    final result = await getPokemonList(
      PaginationParams(limit: _limit, offset: 0),
    );

    result.when(
      (pokemons) => emit(
        state.copyWith(
          isLoading: false,
          pokemons: pokemons,
          currentOffset: _limit,
          hasReachedMax: pokemons.length < _limit,
        ),
      ),
      failure: (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
    );
  }

  Future<void> _onSearch(
    _Search event,
    Emitter<PokemonListState> emit,
  ) async {
    if (event.query.isEmpty) {
      final result = await getPokemonList(
        PaginationParams(limit: _limit, offset: 0),
      );
      result.when(
        (pokemons) => emit(
          state.copyWith(
            isLoading: false,
            pokemons: pokemons,
            currentOffset: _limit,
            hasReachedMax: false,
          ),
        ),
        failure: (failure) => emit(
          state.copyWith(isLoading: false, errorMessage: failure.message),
        ),
      );
      return;
    }

    final filtered = _allPokemon
        .where((p) => p.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();

    emit(
      state.copyWith(
        isLoading: false,
        pokemons: filtered,
        hasReachedMax: true,
      ),
    );
  }

  Future<void> _onLoadMore(
    _LoadMore event,
    Emitter<PokemonListState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final result = await getPokemonList(
      PaginationParams(limit: _limit, offset: state.currentOffset),
    );

    result.when(
      (pokemons) => emit(
        state.copyWith(
          isLoadingMore: false,
          pokemons: [...state.pokemons, ...pokemons],
          currentOffset: state.currentOffset + _limit,
          hasReachedMax: pokemons.length < _limit,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> _onGetByType(
    _GetByType event,
    Emitter<PokemonListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getPokemonByType(event.typeName);

    result.when(
      (pokemons) => emit(state.copyWith(isLoading: false, pokemons: pokemons)),
      failure: (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
    );
  }

  Future<void> _onFetchTypes(
    _FetchTypes event,
    Emitter<PokemonListState> emit,
  ) async {
    emit(state.copyWith(isLoadingTypes: true, typesErrorMessage: null));

    final result = await getPokemonTypes(const NoParams());
    result.when(
      (types) => emit(
        state.copyWith(
          isLoadingTypes: false,
          types: types,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          isLoadingTypes: false,
          typesErrorMessage: failure.message,
        ),
      ),
    );
  }
}
