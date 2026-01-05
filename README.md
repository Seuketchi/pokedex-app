# PokéDex Pro

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Style: Very Good Analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An enterprise-grade Flutter Pokédex application implementing Clean Architecture, BLoC pattern, and
TDD practices.

## About

PokéDex Pro is a production-grade Flutter application that serves as both a functional Pokémon
companion app and a comprehensive showcase of enterprise Flutter development patterns. This project
deliberately employs sophisticated architecture to demonstrate best practices typically reserved for
large-scale applications.

### Project Philosophy

This project embraces **deliberate over-engineering** for educational and portfolio purposes:

- Clean Architecture with strict layer separation
- Test-Driven Development (TDD) workflow
- Comprehensive dependency injection
- Type-safe API integration
- Offline-first data strategy

## Features

### Pokédex List

- Paginated list of Pokémon
- Search functionality by name
- Filter by type
- Pull-to-refresh

### Pokémon Detail

- Base stats visualization
- Type-based theming
- Responsive layout

### Battle Arena *(In Development)*

- Pokémon battle simulation
- Stats comparison

### Core Capabilities

- Offline support with local caching
- Network state handling
- Optimized performance

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation                           │
│                  (BLoC, Pages, Widgets)                     │
├─────────────────────────────────────────────────────────────┤
│                         Domain                              │
│              (Entities, Repositories, UseCases)             │
├─────────────────────────────────────────────────────────────┤
│                          Data                               │
│          (Models, DataSources, Repository Impl)             │
└─────────────────────────────────────────────────────────────┘
```

### Key Patterns

| Pattern              | Implementation                 |
|----------------------|--------------------------------|
| State Management     | BLoC/Cubit with Freezed unions |
| Dependency Injection | GetIt + Injectable             |
| Repository Pattern   | Abstract contracts in Domain   |
| Offline-First        | Hive local caching             |

## Tech Stack

| Category             | Technology                             |
|----------------------|----------------------------------------|
| Framework            | Flutter 3.x                            |
| Language             | Dart 3.x                               |
| State Management     | flutter_bloc, bloc                     |
| Dependency Injection | get_it, injectable                     |
| Networking           | dio, retrofit                          |
| Local Storage        | hive, hive_flutter                     |
| Code Generation      | freezed, json_serializable             |
| Routing              | go_router                              |
| Testing              | mocktail, bloc_test, http_mock_adapter |
| Linting              | very_good_analysis                     |

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/                     # Shared infrastructure
│   ├── constants/            # App-wide constants
│   ├── converter/            # Type converters
│   ├── di/                   # Dependency injection setup
│   ├── error/                # Error handling & failures
│   ├── local/                # Local storage setup
│   ├── network/              # Dio client & network info
│   ├── result/               # Result type utilities
│   ├── usecases/             # Base usecase contracts
│   └── utils/                # Utility functions
│
└── features/                 # Feature modules
    ├── pokemon_list/         # Pokédex list feature
    │   ├── data/
    │   │   ├── datasources/  # Remote & local data sources
    │   │   ├── models/       # Data models (JSON serializable)
    │   │   └── repositories/ # Repository implementations
    │   ├── domain/
    │   │   ├── entities/     # Business entities
    │   │   ├── repositories/ # Repository contracts
    │   │   └── usecases/     # Business logic
    │   └── presentation/
    │       ├── bloc/         # BLoC state management
    │       ├── pages/        # Screen widgets
    │       └── widgets/      # Reusable UI components
    │
    ├── pokemon_detail/       # Pokémon detail feature
    │   └── ... (same structure)
    │
    └── battle_arena/         # Battle arena feature
        └── ... (same structure)

test/
├── core/                     # Core module tests
├── features/                 # Feature tests (mirrors lib/)
├── fixtures/                 # JSON fixtures for testing
└── helpers/                  # Test utilities & mocks
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.4
- Dart SDK ^3.10.4
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pokedex_app.git
   cd pokedex_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Code Generation (Development)

For watch mode during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Testing

### Run all tests

```bash
flutter test
```

### Run tests with coverage

```bash
flutter test --coverage
```

### View coverage report

```bash
# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Testing Philosophy

This project follows **Test-Driven Development (TDD)**:

- Target: ≥80% code coverage
- Tests written before implementation
- Unit tests for all business logic
- Widget tests for UI components
- Integration tests for critical flows

## Scripts

### Create a new feature

```bash
./create_feature.sh <feature_name>
```

This scaffolds the complete Clean Architecture folder structure for a new feature.

### Setup core infrastructure

```bash
./setup_core.sh
```

## Development Commands

| Command                       | Description          |
|-------------------------------|----------------------|
| `flutter pub get`             | Install dependencies |
| `dart run build_runner build` | Run code generation  |
| `flutter analyze`             | Run static analysis  |
| `flutter test`                | Run all tests        |
| `flutter run`                 | Run the app          |

## Quality Standards

| Metric          | Target          |
|-----------------|-----------------|
| Code Coverage   | ≥80%            |
| Static Analysis | 0 warnings      |
| Documentation   | All public APIs |
| Frame Render    | <16ms           |

## API Reference

This app uses the [PokéAPI](https://pokeapi.co/) - a free RESTful Pokémon API.

- Base URL: `https://pokeapi.co/api/v2/`
- No authentication required
- Rate limiting applies

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the existing architecture patterns
4. Write tests for new functionality
5. Ensure all tests pass (`flutter test`)
6. Run static analysis (`flutter analyze`)
7. Commit your changes (`git commit -m 'feat: add amazing feature'`)
8. Push to the branch (`git push origin feature/amazing-feature`)
9. Open a Pull Request

### Commit Convention

This project follows [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `test:` Test additions/modifications
- `refactor:` Code refactoring
- `chore:` Maintenance tasks

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [PokéAPI](https://pokeapi.co/) for the comprehensive Pokémon data
- [Flutter](https://flutter.dev/) team for the amazing framework
- [Bloc Library](https://bloclibrary.dev/) for state management patterns
- [ResoCoder](https://resocoder.com/) for Clean Architecture tutorials

