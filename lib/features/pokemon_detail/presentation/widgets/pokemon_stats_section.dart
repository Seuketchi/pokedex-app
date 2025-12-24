import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_stat.dart';

class PokemonStatsSection extends StatelessWidget {
  final List<PokemonStat> stats;

  const PokemonStatsSection({
    super.key,
    required this.stats,
  });

  String _getStatLabel(String statName) {
    switch (statName.toLowerCase()) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Atk';
      case 'special-defense':
        return 'Sp. Def';
      case 'speed':
        return 'Speed';
      default:
        return statName;
    }
  }

  Color _getStatColor(String statName) {
    switch (statName.toLowerCase()) {
      case 'hp':
        return Colors.red;
      case 'attack':
        return Colors.orange;
      case 'defense':
        return Colors.blue;
      case 'special-attack':
        return Colors.purple;
      case 'special-defense':
        return Colors.green;
      case 'speed':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Base Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            ...stats.map((stat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _StatBar(
                  label: _getStatLabel(stat.name),
                  value: stat.baseStat,
                  color: _getStatColor(stat.name),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / 255).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
