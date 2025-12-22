import 'package:flutter/material.dart';
import 'package:pokedex_app/core/di/injection_container.dart';

void main() {
  configureDependencies();  // ← Initialize DI before running app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}
