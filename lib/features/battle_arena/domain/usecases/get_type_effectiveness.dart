import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/type_effectiveness.dart';
import 'package:pokedex_app/features/battle_arena/domain/repositories/battle_repository.dart';

part 'get_type_effectiveness.freezed.dart';

@injectable
class GetTypeEffectiveness
    implements UseCase<TypeEffectiveness, TypeEffectivenessParams> {
  GetTypeEffectiveness(this.repository);

  final BattleRepository repository;

  @override
  Future<Result<TypeEffectiveness, Failure>> call(
    TypeEffectivenessParams params,
  ) async {
    return repository.getTypeEffectiveness(params.typeName);
  }
}

@freezed
class TypeEffectivenessParams with _$TypeEffectivenessParams {
  const factory TypeEffectivenessParams({required String typeName}) =
      _TypeEffectivenessParams;
}
