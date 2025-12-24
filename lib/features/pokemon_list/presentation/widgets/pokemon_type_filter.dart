import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/core/constants/pokemon_type_config.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/bloc/pokemon_list_bloc.dart';

class PokemonTypeFilter extends StatefulWidget {
  const PokemonTypeFilter({
    required this.onTypeSelected,
    super.key,
  });

  final void Function(String?) onTypeSelected;

  @override
  State<PokemonTypeFilter> createState() => _PokemonTypeFilterState();
}

class _PokemonTypeFilterState extends State<PokemonTypeFilter> {
  String? _selectedType;

  void _handleTypeSelection(PokemonTypeData typeData) {
    setState(() {
      _selectedType = typeData.type;
    });
    widget.onTypeSelected(typeData.type);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonListBloc, PokemonListState>(
      builder: (context, state) {
        // Show loading indicator while fetching types
        if (state.isLoadingTypes) {
          return Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 8),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red[400]!),
                ),
              ),
            ),
          );
        }

        // Show error if types failed to load
        if (state.typesErrorMessage != null) {
          return Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 8),
            child: Center(
              child: Text(
                'Failed to load types',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        }

        // Build type filter from fetched types
        final types = [
          PokemonTypeData(label: 'All', type: null, color: Colors.grey),
          ...state.types.map(
            (type) => PokemonTypeData(
              label: _capitalize(type.name),
              type: type.name,
              color: PokemonTypeConfig.getTypeColor(type.name),
            ),
          ),
        ];

        return Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: types.length,
            itemBuilder: (context, index) {
              final typeData = types[index];
              final isSelected = _selectedType == typeData.type;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _TypeChip(
                  typeData: typeData,
                  isSelected: isSelected,
                  onTap: () => _handleTypeSelection(typeData),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class PokemonTypeData {
  PokemonTypeData({
    required this.label,
    required this.type,
    required this.color,
  });

  final String label;
  final String? type;
  final Color color;
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.typeData,
    required this.isSelected,
    required this.onTap,
  });

  final PokemonTypeData typeData;
  final bool isSelected;
  final VoidCallback onTap;

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
                  : typeData.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: typeData.color,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: typeData.color.withValues(alpha: 0.4),
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
