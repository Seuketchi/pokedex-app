import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:pokedex_app/core/di/injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
