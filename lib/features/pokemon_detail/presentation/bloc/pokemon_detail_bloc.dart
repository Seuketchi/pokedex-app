import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/usecases/get_evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/usecases/get_pokemon_detail.dart';

part 'pokemon_detail_bloc.freezed.dart';
part 'pokemon_detail_event.dart';
part 'pokemon_detail_state.dart';

@injectable
class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  PokemonDetailBloc(
    this.getPokemonDetail,
    this.getEvolutionChain,
  ) : super(const PokemonDetailState()) {
    on<_LoadDetail>(_onLoadDetail);
    on<_LoadEvolution>(_onLoadEvolution);
  }

  final GetPokemonDetail getPokemonDetail;
  final GetEvolutionChain getEvolutionChain;

  Future<void> _onLoadDetail(
    _LoadDetail event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetail: true, detailErrorMessage: null));

    final result = await getPokemonDetail(PokemonIdParams(id: event.id));

    result.when(
      (detail) => emit(
        state.copyWith(
          isLoadingDetail: false,
          pokemonDetail: detail,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          isLoadingDetail: false,
          detailErrorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> _onLoadEvolution(
    _LoadEvolution event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(state.copyWith(isLoadingEvolution: true, evolutionErrorMessage: null));

    final result = await getEvolutionChain(
      SpeciesIdParams(speciesId: event.speciesId),
    );

    result.when(
      (chain) => emit(
        state.copyWith(
          isLoadingEvolution: false,
          evolutionChain: chain,
        ),
      ),
      failure: (failure) => emit(
        state.copyWith(
          isLoadingEvolution: false,
          evolutionErrorMessage: failure.message,
        ),
      ),
    );
  }
}
