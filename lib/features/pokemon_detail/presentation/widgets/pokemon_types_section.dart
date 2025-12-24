import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/pokemon_type_config.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_type.dart';

class PokemonTypesSection extends StatelessWidget {
  final List<PokemonType> types;

  const PokemonTypesSection({
    super.key,
    required this.types,
  });

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: types.map((type) {
          final color = PokemonTypeConfig.getTypeColor(type.name);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _capitalize(type.name),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
