import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/pokemon_type_config.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';

class MoveButtons extends StatelessWidget {
  const MoveButtons({
    required this.moves,
    required this.onMoveSelected,
    super.key,
  });

  final List<Move> moves;
  final ValueChanged<Move> onMoveSelected;

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
        ),
        itemCount: moves.length,
        itemBuilder: (context, index) {
          final move = moves[index];
          final typeColor = PokemonTypeConfig.getTypeColor(move.type);

          return ElevatedButton(
            onPressed: () => onMoveSelected(move),
            style: ElevatedButton.styleFrom(
              backgroundColor: typeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _capitalize(move.name),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'PWR: ${move.power}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
