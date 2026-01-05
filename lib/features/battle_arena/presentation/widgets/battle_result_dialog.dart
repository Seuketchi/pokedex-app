import 'package:flutter/material.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_pokemon.dart';

class BattleResultDialog extends StatelessWidget {
  const BattleResultDialog({
    required this.winner,
    required this.onNewBattle,
    required this.onQuit,
    super.key,
  });

  final BattlePokemon winner;
  final VoidCallback onNewBattle;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text(
              'BATTLE OVER!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(
              winner.imageUrl,
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 8),
            Text(
              '${winner.name.toUpperCase()} WINS!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNewBattle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'NEW BATTLE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onQuit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'QUIT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
