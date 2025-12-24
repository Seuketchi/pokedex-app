import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';

class PokemonInfoSection extends StatelessWidget {
  const PokemonInfoSection({
    required this.detail,
    super.key,
  });
  final PokemonDetail detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.height,
                    label: 'Height',
                    value: '${detail.height / 10} m',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.monitor_weight,
                    label: 'Weight',
                    value: '${detail.weight / 10} kg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.star,
              label: 'Base Experience',
              value: '${detail.baseExperience}',
            ),
            const SizedBox(height: 12),
            const Text(
              'Abilities',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: detail.abilities.map((ability) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ability.isHidden
                        ? Colors.purple[100]
                        : Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (ability.isHidden)
                        Icon(
                          Icons.visibility_off,
                          size: 14,
                          color: Colors.purple[700],
                        ),
                      if (ability.isHidden) const SizedBox(width: 4),
                      Text(
                        _capitalize(ability.name),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ability.isHidden
                              ? Colors.purple[700]
                              : Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) {
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.red[400]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
