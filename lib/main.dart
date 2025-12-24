import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_app/core/di/injection_container.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/bloc/pokemon_list_bloc.dart';
import 'package:pokedex_app/features/pokemon_list/presentation/pages/pokemon_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: BlocProvider(
        create: (_) =>
            GetIt.I<PokemonListBloc>()..add(const PokemonListEvent.fetch()),
        child: const PokemonListPage(),
      ),
    );
  }
}
