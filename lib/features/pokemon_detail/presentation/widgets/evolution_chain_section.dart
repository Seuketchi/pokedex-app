import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_node.dart';

class EvolutionChainSection extends StatelessWidget {
  final EvolutionChain chain;

  const EvolutionChainSection({
    super.key,
    required this.chain,
  });

  List<EvolutionNode> _flattenChain(EvolutionNode node) {
    final List<EvolutionNode> result = [node];
    for (final evolution in node.evolvesTo) {
      result.addAll(_flattenChain(evolution));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final flatChain = _flattenChain(chain.chain);

    if (flatChain.length == 1) {
      return const SizedBox.shrink();
    }

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
              'Evolution Chain',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            _buildEvolutionChain(chain.chain),
          ],
        ),
      ),
    );
  }

  Widget _buildEvolutionChain(EvolutionNode node) {
    if (node.evolvesTo.isEmpty) {
      return _EvolutionItem(node: node);
    }

    return Column(
      children: [
        _EvolutionItem(node: node),
        ...node.evolvesTo.map((evolution) {
          return Column(
            children: [
              _EvolutionArrow(
                trigger: evolution.trigger,
                minLevel: evolution.minLevel,
                item: evolution.item,
              ),
              _buildEvolutionChain(evolution),
            ],
          );
        }).toList(),
      ],
    );
  }
}

class _EvolutionItem extends StatelessWidget {
  final EvolutionNode node;

  const _EvolutionItem({required this.node});

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${node.speciesId}.png';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              imageUrl,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.catching_pokemon,
                  size: 30,
                  color: Colors.red[300],
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _capitalize(node.speciesName),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
}

class _EvolutionArrow extends StatelessWidget {
  final String? trigger;
  final int? minLevel;
  final String? item;

  const _EvolutionArrow({
    this.trigger,
    this.minLevel,
    this.item,
  });

  String _getEvolutionText() {
    if (minLevel != null) {
      return 'Level $minLevel';
    }
    if (item != null) {
      return _capitalize(item!.replaceAll('-', ' '));
    }
    return 'Evolves';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Icon(
            Icons.arrow_downward,
            color: Colors.red[400],
            size: 24,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getEvolutionText(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
