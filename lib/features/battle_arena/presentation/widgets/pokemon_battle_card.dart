import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/pokemon_type_config.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_pokemon.dart';

class PokemonBattleCard extends StatelessWidget {
  const PokemonBattleCard({
    required this.pokemon,
    required this.isOpponent,
    super.key,
  });

  final BattlePokemon pokemon;
  final bool isOpponent;

  @override
  Widget build(BuildContext context) {
    final hpPercentage = pokemon.currentHp / pokemon.maxHp;

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pokemon Image
              Image.network(
                pokemon.imageUrl,
                height: 80,
                width: 80,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.catching_pokemon,
                    size: 80,
                    color: Colors.grey[400],
                  );
                },
              ),

              const SizedBox(height: 4),

              // Pokemon Name
              Text(
                pokemon.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Types
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: pokemon.types.map((type) {
                  final color = PokemonTypeConfig.getTypeColor(type);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      type.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              // HP Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${pokemon.currentHp} / ${pokemon.maxHp}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: hpPercentage,
                      minHeight: 14,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        hpPercentage > 0.5
                            ? Colors.green
                            : hpPercentage > 0.25
                            ? Colors.orange
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
