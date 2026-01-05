import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_pokemon.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';

part 'calculate_damage.freezed.dart';

@injectable
class CalculateDamage implements UseCase<int, CalculateDamageParams> {
  @override
  Future<Result<int, Failure>> call(CalculateDamageParams params) async {
    // Pokemon damage formula (simplified):
    // Damage = ((2 * Level / 5 + 2) * Power * Attack / Defense / 50 + 2) * Modifier
    // We'll use Level = 50 (standard battle level)
    // Modifier includes type effectiveness (passed as parameter)

    const level = 50;
    final power = params.move.power;
    final attack = params.attacker.attack;
    final defense = params.defender.defense;
    final effectiveness = params.typeEffectiveness;

    // Base damage calculation
    final baseDamage = ((2 * level / 5 + 2) * power * attack / defense / 50 + 2)
        .floor();

    // Apply type effectiveness
    final finalDamage = (baseDamage * effectiveness).floor();

    // Ensure minimum damage of 1
    final damage = finalDamage < 1 ? 1 : finalDamage;

    return ResultSuccess(damage);
  }
}

@freezed
class CalculateDamageParams with _$CalculateDamageParams {
  const factory CalculateDamageParams({
    required BattlePokemon attacker,
    required BattlePokemon defender,
    required Move move,
    required double typeEffectiveness,
  }) = _CalculateDamageParams;
}
