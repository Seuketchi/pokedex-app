import 'package:flutter/material.dart';

class PokemonTypeFilter extends StatefulWidget {
  final Function(String?) onTypeSelected;

  const PokemonTypeFilter({
    super.key,
    required this.onTypeSelected,
  });

  @override
  State<PokemonTypeFilter> createState() => _PokemonTypeFilterState();
}

class _PokemonTypeFilterState extends State<PokemonTypeFilter> {
  String? _selectedType;

  final List<PokemonTypeData> _types = [
    PokemonTypeData(label: 'All', type: null, color: Colors.grey),
    PokemonTypeData(
      label: 'Fire',
      type: 'fire',
      color: const Color(0xFFFF6B6B),
    ),
    PokemonTypeData(
      label: 'Water',
      type: 'water',
      color: const Color(0xFF4ECDC4),
    ),
    PokemonTypeData(
      label: 'Grass',
      type: 'grass',
      color: const Color(0xFF95E1D3),
    ),
    PokemonTypeData(
      label: 'Electric',
      type: 'electric',
      color: const Color(0xFFFECA57),
    ),
    PokemonTypeData(
      label: 'Psychic',
      type: 'psychic',
      color: const Color(0xFFFF85E1),
    ),
    PokemonTypeData(
      label: 'Rock',
      type: 'rock',
      color: const Color(0xFFB8B08D),
    ),
    PokemonTypeData(label: 'Ice', type: 'ice', color: const Color(0xFF98D8E8)),
  ];

  void _handleTypeSelection(PokemonTypeData typeData) {
    setState(() {
      _selectedType = typeData.type;
    });
    widget.onTypeSelected(typeData.type);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _types.length,
        itemBuilder: (context, index) {
          final typeData = _types[index];
          final isSelected = _selectedType == typeData.type;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _TypeChip(
              typeData: typeData,
              isSelected: isSelected,
              onTap: () => _handleTypeSelection(typeData),
            ),
          );
        },
      ),
    );
  }
}

class PokemonTypeData {
  final String label;
  final String? type;
  final Color color;

  PokemonTypeData({
    required this.label,
    required this.type,
    required this.color,
  });
}

class _TypeChip extends StatelessWidget {
  final PokemonTypeData typeData;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.typeData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? typeData.color
                  : typeData.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: typeData.color,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: typeData.color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              typeData.label,
              style: TextStyle(
                color: isSelected ? Colors.white : typeData.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
