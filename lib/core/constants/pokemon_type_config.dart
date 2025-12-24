import 'package:flutter/material.dart';

class PokemonTypeConfig {
  static const Map<String, Color> typeColors = {
    'fire': Color(0xFFFF6B6B),
    'water': Color(0xFF4ECDC4),
    'grass': Color(0xFF95E1D3),
    'electric': Color(0xFFFECA57),
    'psychic': Color(0xFFFF85E1),
    'rock': Color(0xFFB8B08D),
    'ice': Color(0xFF98D8E8),
    'poison': Color(0xFF9B59B6),
    'bug': Color(0xFFA8E6CF),
    'flying': Color(0xFFB2BABB),
    'normal': Color(0xFFBDC3C7),
    'ground': Color(0xFFD4A373),
    'fighting': Color(0xFFE74C3C),
    'ghost': Color(0xFF9980FA),
    'dragon': Color(0xFF6C5CE7),
    'dark': Color(0xFF34495E),
    'steel': Color(0xFF95A5A6),
    'fairy': Color(0xFFFDCB6E),
  };

  static Color getTypeColor(String typeName) {
    return typeColors[typeName.toLowerCase()] ?? Colors.grey;
  }

  static List<PokemonTypeData> get allTypes => [
    PokemonTypeData(label: 'All', type: null, color: Colors.grey),
    PokemonTypeData(label: 'Fire', type: 'fire', color: typeColors['fire']!),
    PokemonTypeData(label: 'Water', type: 'water', color: typeColors['water']!),
    PokemonTypeData(label: 'Grass', type: 'grass', color: typeColors['grass']!),
    PokemonTypeData(
      label: 'Electric',
      type: 'electric',
      color: typeColors['electric']!,
    ),
    PokemonTypeData(
      label: 'Psychic',
      type: 'psychic',
      color: typeColors['psychic']!,
    ),
    PokemonTypeData(label: 'Rock', type: 'rock', color: typeColors['rock']!),
    PokemonTypeData(label: 'Ice', type: 'ice', color: typeColors['ice']!),
    PokemonTypeData(
      label: 'Poison',
      type: 'poison',
      color: typeColors['poison']!,
    ),
    PokemonTypeData(label: 'Bug', type: 'bug', color: typeColors['bug']!),
    PokemonTypeData(
      label: 'Flying',
      type: 'flying',
      color: typeColors['flying']!,
    ),
    PokemonTypeData(
      label: 'Normal',
      type: 'normal',
      color: typeColors['normal']!,
    ),
    PokemonTypeData(
      label: 'Ground',
      type: 'ground',
      color: typeColors['ground']!,
    ),
    PokemonTypeData(
      label: 'Fighting',
      type: 'fighting',
      color: typeColors['fighting']!,
    ),
    PokemonTypeData(label: 'Ghost', type: 'ghost', color: typeColors['ghost']!),
    PokemonTypeData(
      label: 'Dragon',
      type: 'dragon',
      color: typeColors['dragon']!,
    ),
    PokemonTypeData(label: 'Dark', type: 'dark', color: typeColors['dark']!),
    PokemonTypeData(label: 'Steel', type: 'steel', color: typeColors['steel']!),
    PokemonTypeData(label: 'Fairy', type: 'fairy', color: typeColors['fairy']!),
  ];
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
