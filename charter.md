# PokéDex Pro: Project Charter

> An "Overkill" Flutter Application Implementing Enterprise-Grade Architecture & Best Practices

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Objectives & Learning Goals](#2-objectives--learning-goals)
3. [Scope Definition](#3-scope-definition)
4. [Clean Architecture Deep Dive](#4-clean-architecture-deep-dive)
5. [Technology Stack & Justifications](#5-technology-stack--justifications)
6. [Feature Specifications](#6-feature-specifications)
7. [BLoC Architecture Patterns](#7-bloc-architecture-patterns)
8. [Test-Driven Development Workflow](#8-test-driven-development-workflow)
9. [GitFlow Strategy](#9-gitflow-strategy)
10. [CI/CD Pipeline](#10-cicd-pipeline)
11. [Development Phases](#11-development-phases)
12. [Quality Standards & Conventions](#12-quality-standards--conventions)
13. [API Integration Strategy](#13-api-integration-strategy)
14. [Appendices](#14-appendices)

---

## 1. Project Overview

### 1.1 Project Identity

**Project Name:** PokéDex Pro  
**Project Type:** Mobile Application (iOS & Android)  
**Duration:** 8-12 weeks (self-paced learning project)  
**Primary Developer:** Individual/Learning Project

### 1.2 Vision Statement

To build a production-grade Flutter application that serves as both a functional Pokémon companion app and a comprehensive learning vehicle for mastering enterprise Flutter development patterns. This project intentionally employs "overkill" architecture to provide hands-on experience with patterns typically reserved for large-scale applications.

### 1.3 Project Philosophy

This project embraces the concept of **deliberate over-engineering** for educational purposes. In production, you would scale complexity to match project needs. Here, we deliberately implement sophisticated patterns on a manageable domain (Pokémon data) so you can:

- Focus on learning patterns without domain complexity
- Make mistakes in a low-stakes environment
- Build muscle memory for enterprise patterns
- Create a portfolio piece demonstrating architectural maturity

---

## 2. Objectives & Learning Goals

### 2.1 Primary Objectives

| Objective | Success Indicator |
|-----------|-------------------|
| Implement Clean Architecture | Clear separation between Data, Domain, and Presentation layers with no cross-layer violations |
| Master BLoC Pattern | All UI state managed through BLoC/Cubit with proper event/state design |
| Practice TDD | Minimum 80% code coverage with tests written before implementation |
| Utilize Code Generation | Freezed for immutable models, Injectable for DI, json_serializable for JSON |
| Implement Proper DI | GetIt service locator with Injectable for compile-time safety |
| Establish Professional Workflow | GitFlow branching, CI/CD pipeline, automated quality gates |

### 2.2 Learning Goals

By project completion, you should be able to:

1. **Explain** why Clean Architecture matters and when to use it
2. **Implement** the dependency rule without violations
3. **Design** BLoC events and states using union types
4. **Practice** the red-green-refactor TDD cycle fluently
5. **Configure** GitHub Actions for Flutter CI/CD
6. **Navigate** GitFlow branching without confusion
7. **Debug** dependency injection issues confidently
8. **Articulate** trade-offs between architectural approaches

### 2.3 Success Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Code Coverage | ≥80% | `flutter test --coverage` |
| Static Analysis | 0 warnings | `flutter analyze` |
| Build Success Rate | 100% | CI/CD pipeline |
| Documentation | All public APIs | `dart doc` generation |
| Performance | <16ms frame render | Flutter DevTools |

---

## 3. Scope Definition

### 3.1 Features In Scope

#### MVP (Minimum Viable Product)

1. **Pokédex List View**
    - Paginated list of Pokémon (first 151 for MVP)
    - Search functionality by name
    - Filter by type
    - Pull-to-refresh

2. **Pokémon Detail View**
    - Base stats visualization
    - Type information with effectiveness
    - Evolution chain display
    - Moves list
    - Abilities with descriptions

3. **Battle Arena**
    - Select two Pokémon for battle
    - Turn-based combat system
    - Type effectiveness calculations
    - HP tracking and victory conditions

#### Post-MVP Enhancements

- Favorites/team building
- Offline caching
- Animations and polish
- Sound effects
- Dark/light theme

### 3.2 Explicit Exclusions

To maintain focus, the following are explicitly out of scope:

- User authentication
- Backend server development
- Real-time multiplayer
- In-app purchases
- Push notifications
- Social features

### 3.3 Technical Constraints

- **API Dependency:** All data sourced from PokéAPI (https://pokeapi.co/)
- **Rate Limiting:** PokéAPI has fair use policies; implement caching
- **Offline:** Graceful degradation when network unavailable
- **Platform:** iOS 12+ and Android API 21+

---

## 4. Clean Architecture Deep Dive

### 4.1 Why Clean Architecture?

Clean Architecture, popularized by Robert C. Martin (Uncle Bob), solves several problems:

1. **Framework Independence:** Your business logic doesn't depend on Flutter
2. **Testability:** Business rules can be tested without UI, database, or external services
3. **UI Independence:** The UI can change without changing the rest of the system
4. **Database Independence:** Your business rules don't know anything about the database
5. **External Agency Independence:** Business rules don't know about the outside world

### 4.2 The Three Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Widgets   │  │    BLoCs    │  │   State Classes     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│                           │                                  │
│                           ▼                                  │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │  Use Cases  │  │ Repository Contracts │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│                           ▲                                  │
│                           │                                  │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │Repositories │  │    Data Sources     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

#### 4.2.1 Domain Layer (Innermost)

The **Domain Layer** is the heart of your application. It contains:

**Entities:** Pure Dart classes representing your core business objects. They have no dependencies on any other layer or external packages. An entity knows what a Pokémon *is*, not how it's stored or displayed.

**Use Cases (Interactors):** Single-purpose classes that encapsulate one business operation. Each use case should do exactly one thing. Examples: `GetPokemonList`, `GetPokemonDetails`, `CalculateBattleDamage`. Use cases orchestrate entities and call repository methods.

**Repository Contracts (Abstract Classes):** Interfaces that define what data operations are available. The domain layer only knows these abstractions exist, not how they're implemented. This is the **Dependency Inversion Principle** in action.

**Why This Matters:** If PokéAPI shuts down tomorrow, you only change the Data layer. Your business logic (Domain) and UI (Presentation) remain untouched.

#### 4.2.2 Data Layer (Outermost)

The **Data Layer** implements the repository contracts and handles all external communication:

**Models:** Data Transfer Objects (DTOs) that know how to serialize/deserialize from JSON. Models map to/from domain entities. They are "dumb" data containers with fromJson/toJson capabilities.

**Repository Implementations:** Concrete classes implementing domain repository contracts. They coordinate between data sources and transform models to entities.

**Data Sources:** Classes that actually fetch data. Split into:
- **Remote Data Sources:** API calls via Dio/Retrofit
- **Local Data Sources:** Cache via Hive/SharedPreferences/SQLite

**Why This Matters:** The Data layer is a plugin. You could swap PokéAPI for a GraphQL backend or local database, and Domain/Presentation wouldn't know.

#### 4.2.3 Presentation Layer

The **Presentation Layer** handles everything the user sees and interacts with:

**Widgets:** Flutter UI components. They should be "dumb" and only know how to render state. No business logic belongs here.

**BLoCs/Cubits:** State management components that receive events and emit states. They call use cases and transform results into UI-consumable states.

**State Classes:** Immutable representations of UI state. Built with Freezed for union types and copyWith functionality.

**Why This Matters:** You could replace Flutter with a CLI interface, and only this layer would change.

### 4.3 The Dependency Rule

**The Golden Rule:** Dependencies only point inward. Outer layers can depend on inner layers, never the reverse.

```
Presentation → Domain ← Data
     │            ↑        │
     │            │        │
     └────────────┴────────┘
         (both depend on Domain)
```

**Practical Implications:**

- Domain layer imports nothing from Data or Presentation
- Data layer imports from Domain (to implement contracts and use entities)
- Presentation layer imports from Domain (to call use cases and use entities)
- Data and Presentation never directly communicate

### 4.4 Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── network_info.dart
│   │   └── api_client.dart
│   ├── usecases/
│   │   └── usecase.dart          # Base UseCase class
│   └── utils/
│       ├── either.dart           # Functional error handling
│       └── type_extensions.dart
│
├── features/
│   ├── pokemon_list/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── pokemon_remote_datasource.dart
│   │   │   │   └── pokemon_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── pokemon_model.dart
│   │   │   │   └── pokemon_model.g.dart
│   │   │   └── repositories/
│   │   │       └── pokemon_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── pokemon.dart
│   │   │   ├── repositories/
│   │   │   │   └── pokemon_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_pokemon_list.dart
│   │   │       └── search_pokemon.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── pokemon_list_bloc.dart
│   │       │   ├── pokemon_list_event.dart
│   │       │   └── pokemon_list_state.dart
│   │       ├── pages/
│   │       │   └── pokemon_list_page.dart
│   │       └── widgets/
│   │           ├── pokemon_card.dart
│   │           └── pokemon_search_bar.dart
│   │
│   ├── pokemon_detail/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── battle_arena/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── injection_container.dart      # GetIt setup
└── main.dart
```

### 4.5 Feature-First vs Layer-First

This project uses **Feature-First** organization within Clean Architecture:

**Feature-First (Chosen):** Group by feature, then by layer
- Pros: Related code stays together, easier navigation, natural code splitting
- Cons: Shared code needs a `core/` or `shared/` folder

**Layer-First (Alternative):** Group by layer, then by feature
- Pros: Clear layer boundaries, good for small projects
- Cons: Related code scattered, harder to find all pieces of a feature

---

## 5. Technology Stack & Justifications

### 5.1 Core Framework

| Technology | Version | Justification |
|------------|---------|---------------|
| Flutter | 3.x (latest stable) | Cross-platform, single codebase, hot reload |
| Dart | 3.x | Null safety, records, patterns, sealed classes |

**Dart 3 Features to Leverage:**

- **Records:** Lightweight data structures for multiple return values
- **Patterns:** Destructuring and pattern matching for cleaner code
- **Sealed Classes:** Exhaustive switch statements for states
- **Class Modifiers:** `final`, `sealed`, `interface`, `base`, `mixin`

### 5.2 State Management

| Package | Purpose | Justification |
|---------|---------|---------------|
| flutter_bloc | State management | Predictable, testable, separation of concerns |
| bloc | Core BLoC library | Event-driven architecture |

**Why BLoC over Riverpod/Provider/GetX?**

- **Predictability:** Unidirectional data flow (Event → BLoC → State)
- **Testability:** bloc_test package makes testing trivial
- **Scalability:** Proven in large production applications
- **Separation:** Forces you to separate business logic from UI
- **Tooling:** Excellent DevTools integration

### 5.3 Code Generation

| Package | Purpose | Justification |
|---------|---------|---------------|
| freezed | Immutable classes, unions | Eliminates boilerplate for copyWith, ==, hashCode |
| freezed_annotation | Freezed annotations | Required for Freezed |
| json_serializable | JSON serialization | Type-safe JSON parsing |
| json_annotation | JSON annotations | Required for json_serializable |
| injectable | DI code generation | Type-safe dependency injection |
| injectable_generator | Injectable generator | Generates GetIt registration |

**Why Code Generation?**

Writing boilerplate is error-prone and tedious. Code generation:

- Guarantees correctness (generated code is consistent)
- Saves development time
- Keeps code DRY
- Enables advanced patterns (union types) without manual effort

**Build Runner Command:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5.4 Dependency Injection

| Package | Purpose | Justification |
|---------|---------|---------------|
| get_it | Service locator | Simple, fast, no code generation required |
| injectable | Type-safe DI | Compile-time safety, reduces GetIt boilerplate |

**Why GetIt + Injectable?**

- **GetIt alone** requires manual registration (error-prone at scale)
- **Injectable** generates registration code from annotations
- **Compile-time safety:** Errors caught during code generation, not runtime
- **Lazy vs Eager:** Control when dependencies are instantiated

**Injection Scopes:**

- `@singleton` - Single instance for app lifetime
- `@lazySingleton` - Single instance, created on first use
- `@injectable` - New instance each time
- `@Environment` - Different implementations per environment (dev/prod)

### 5.5 Networking

| Package | Purpose | Justification |
|---------|---------|---------------|
| dio | HTTP client | Interceptors, error handling, cancelation |
| retrofit | Type-safe API | Code generation for API calls |
| retrofit_generator | Retrofit generator | Generates Dio implementations |

**Why Dio over http package?**

- Interceptors for logging, auth, retry logic
- Request/response transformers
- Cancel tokens for request cancellation
- Better error handling
- FormData and file upload support

**Why Retrofit?**

- Eliminates manual URL construction
- Type-safe request/response
- Automatic JSON serialization
- Clean, declarative API definition

### 5.6 Local Storage & Caching

| Package | Purpose | Justification |
|---------|---------|---------------|
| hive | Local database | Fast, lightweight, no native dependencies |
| hive_flutter | Flutter integration | Initializes Hive for Flutter |

**Caching Strategy:**

1. Check cache first (Hive)
2. If cache hit and fresh, return cached data
3. If cache miss or stale, fetch from API
4. Store API response in cache
5. Return data

### 5.7 Functional Programming Utilities

| Package | Purpose | Justification |
|---------|---------|---------------|
| dartz (or fpdart) | Functional programming | Either, Option for error handling |

**Why Either for Error Handling?**

Instead of throwing exceptions:

```
Either<Failure, Success>
```

- **Left:** Failure case (error)
- **Right:** Success case (data)

Benefits:
- Explicit error handling (can't forget to handle errors)
- No try-catch boilerplate
- Composable operations
- Type-safe error information

### 5.8 Testing

| Package | Purpose | Justification |
|---------|---------|---------------|
| flutter_test | Widget testing | Built-in Flutter testing |
| bloc_test | BLoC testing | Simplified BLoC/Cubit testing |
| mocktail | Mocking | Modern, null-safe mocking |
| integration_test | Integration testing | Full app testing |

**Why Mocktail over Mockito?**

- No code generation required
- Cleaner syntax
- Full null-safety support
- Less boilerplate

### 5.9 Code Quality

| Package | Purpose | Justification |
|---------|---------|---------------|
| very_good_analysis | Lint rules | Strict, production-grade rules |

**Why very_good_analysis?**

Created by Very Good Ventures (Flutter experts), it enforces:
- Strict type safety
- Documentation requirements
- Consistent style
- Best practices

### 5.10 Development Tools

| Tool | Purpose | Justification |
|------|---------|---------------|
| FVM | Flutter version management | Project-specific Flutter versions |
| Very Good CLI | Project scaffolding | Generates Clean Architecture boilerplate |
| flutter_gen | Asset code generation | Type-safe asset references |

---

## 6. Feature Specifications

### 6.1 Pokédex List Feature

#### User Stories

| ID | As a... | I want to... | So that... |
|----|---------|--------------|------------|
| PL-01 | User | See a list of Pokémon | I can browse all available Pokémon |
| PL-02 | User | Load more Pokémon as I scroll | I don't wait for all data upfront |
| PL-03 | User | Search Pokémon by name | I can find specific Pokémon quickly |
| PL-04 | User | Filter by Pokémon type | I can explore Pokémon of specific types |
| PL-05 | User | Pull to refresh the list | I can get the latest data |
| PL-06 | User | See loading indicators | I know data is being fetched |
| PL-07 | User | See error messages | I understand when something goes wrong |

#### Acceptance Criteria

**PL-01: List Display**
- Given the app launches
- When the Pokédex tab is selected
- Then display Pokémon in a scrollable grid/list
- And show sprite image, name, and types for each

**PL-02: Pagination**
- Given 20 Pokémon are displayed
- When the user scrolls to the bottom
- Then load the next 20 Pokémon
- And append them to the existing list
- And show a loading indicator during fetch

**PL-03: Search**
- Given the search bar is focused
- When the user types "pika"
- Then filter the list to show matching Pokémon
- And update results as the user types (debounced)

#### Technical Considerations

- Implement infinite scroll pagination
- Debounce search input (300ms recommended)
- Cache list data for offline access
- Handle empty states gracefully
- Implement skeleton loading for better UX

### 6.2 Pokémon Detail Feature

#### User Stories

| ID | As a... | I want to... | So that... |
|----|---------|--------------|------------|
| PD-01 | User | View detailed stats | I can understand the Pokémon's strengths |
| PD-02 | User | See type effectiveness | I know battle advantages/disadvantages |
| PD-03 | User | View evolution chain | I can see how this Pokémon evolves |
| PD-04 | User | Browse available moves | I can plan battle strategies |
| PD-05 | User | Read ability descriptions | I understand special abilities |

#### Acceptance Criteria

**PD-01: Base Stats**
- Given a Pokémon detail page
- Then display HP, Attack, Defense, Sp. Atk, Sp. Def, Speed
- And show stats as visual bars (percentage of max 255)
- And show numerical values

**PD-03: Evolution Chain**
- Given the Pokémon has evolutions
- Then display the complete evolution chain
- And show evolution triggers (level, item, trade)
- And allow tapping to navigate to evolved forms

#### Technical Considerations

- Multiple API calls may be needed (pokemon, species, evolution-chain)
- Consider parallel API calls for performance
- Large sprites should be cached
- Stats visualization should be accessible (not just color-coded)

### 6.3 Battle Arena Feature

#### User Stories

| ID | As a... | I want to... | So that... |
|----|---------|--------------|------------|
| BA-01 | User | Select two Pokémon for battle | I can simulate battles |
| BA-02 | User | See turn-by-turn combat | I can follow the battle progress |
| BA-03 | User | See damage calculations | I understand battle mechanics |
| BA-04 | User | See type effectiveness applied | I learn type matchups |
| BA-05 | User | See a winner declared | I know the battle outcome |

#### Acceptance Criteria

**BA-01: Pokémon Selection**
- Given the battle arena is opened
- Then show two selection slots
- When a slot is tapped, show Pokémon picker
- And show selected Pokémon with stats preview

**BA-02: Battle Flow**
- Given two Pokémon are selected
- When "Start Battle" is pressed
- Then enter turn-based combat
- And show current HP for both Pokémon
- And allow move selection per turn
- And show damage dealt per attack

**BA-04: Type Effectiveness**
- Given an attack is made
- Then calculate type effectiveness multiplier
- And display "Super Effective!" (2x, 4x)
- And display "Not Very Effective..." (0.5x, 0.25x)
- And display "No Effect!" (0x)

#### Technical Considerations

- Battle logic belongs in Domain layer (pure Dart, no Flutter)
- Use Entity relationships for type effectiveness chart
- Consider random factor in damage (0.85-1.00 multiplier)
- Store type chart as constant data (no API needed)

#### Simplified Damage Formula

```
Damage = ((2 * Level / 5 + 2) * Power * (Attack / Defense) / 50 + 2) * Modifier

Where Modifier = STAB * TypeEffectiveness * Random(0.85, 1.00)
STAB = 1.5 if move type matches Pokémon type, else 1.0
```

---

## 7. BLoC Architecture Patterns

### 7.1 Core Concepts

**BLoC** (Business Logic Component) is a predictable state management pattern:

```
UI → Event → BLoC → State → UI
```

1. **User interacts** with the UI (tap, scroll, type)
2. **UI dispatches** an Event to the BLoC
3. **BLoC processes** the event (calls use cases, transforms data)
4. **BLoC emits** a new State
5. **UI rebuilds** based on the new State

### 7.2 BLoC vs Cubit

**Cubit:** Simplified BLoC without explicit events

```
UI → Method Call → Cubit → State → UI
```

**When to use Cubit:**
- Simple state changes
- Direct method calls suffice
- No need to track/replay events
- Simpler to understand

**When to use BLoC:**
- Complex event handling
- Event debouncing/throttling
- Event transformation needed
- Better traceability of what triggered state changes

**Rule of Thumb:** Start with Cubit, upgrade to BLoC when needed.

### 7.3 Event Design Principles

Events represent **what happened**, not what should happen:

**Good Event Names:**
- `PokemonListFetched` - Past tense, describes occurrence
- `SearchQueryChanged` - Describes what changed
- `PokemonSelected` - User action completed

**Bad Event Names:**
- `FetchPokemonList` - Imperative, sounds like a command
- `LoadData` - Too vague
- `ButtonPressed` - Implementation detail

**Event Class Structure with Freezed:**

```
// Events as sealed class with union types
@freezed
class PokemonListEvent with _$PokemonListEvent {
  const factory PokemonListEvent.started() = _Started;
  const factory PokemonListEvent.refreshed() = _Refreshed;
  const factory PokemonListEvent.nextPageRequested() = _NextPageRequested;
  const factory PokemonListEvent.searchQueryChanged(String query) = _SearchQueryChanged;
  const factory PokemonListEvent.filterChanged(PokemonType? type) = _FilterChanged;
}
```

### 7.4 State Design Principles

States represent the **current UI state**, including all data needed to render:

**State Properties to Consider:**
- Loading/loaded/error status
- Actual data (list of Pokémon)
- Metadata (current page, has more pages)
- User input state (search query, filters)

**State Class Structure with Freezed:**

```
@freezed
class PokemonListState with _$PokemonListState {
  const factory PokemonListState({
    @Default(Status.initial) Status status,
    @Default([]) List<Pokemon> pokemon,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    @Default('') String searchQuery,
    PokemonType? activeFilter,
    Failure? failure,
  }) = _PokemonListState;
}

enum Status { initial, loading, success, failure }
```

**Alternative: Union State Types**

For simpler BLoCs, use union types for mutually exclusive states:

```
@freezed
class PokemonDetailState with _$PokemonDetailState {
  const factory PokemonDetailState.initial() = _Initial;
  const factory PokemonDetailState.loading() = _Loading;
  const factory PokemonDetailState.loaded(PokemonDetail pokemon) = _Loaded;
  const factory PokemonDetailState.error(Failure failure) = _Error;
}
```

### 7.5 BLoC-to-BLoC Communication

Sometimes BLoCs need to communicate. Options:

**Option 1: Stream Subscription (Recommended)**
- BLoC A listens to BLoC B's state stream
- Useful when BLoC A needs to react to BLoC B's state changes

**Option 2: Shared Use Case**
- Both BLoCs call the same use case
- Data stays in sync via repository

**Option 3: BLoC Listener in UI**
- Widget uses BlocListener to bridge BLoCs
- Dispatches event to BLoC B when BLoC A emits specific state

**Anti-Pattern:** Direct BLoC references (BLoC A holds reference to BLoC B)
- Tight coupling
- Testing becomes difficult
- Violates single responsibility

### 7.6 BLoC Best Practices

1. **One BLoC per feature screen** - Avoid mega-BLoCs
2. **Keep BLoCs focused** - Single responsibility
3. **Don't expose emit** - States only change via event handling
4. **Use transformers for debouncing** - Built-in event transformers
5. **Always handle all events** - Exhaustive switch statements
6. **Test every state transition** - Use bloc_test

---

## 8. Test-Driven Development Workflow

### 8.1 The TDD Cycle

```
┌─────────────────────────────────────────────┐
│                                             │
│    ┌───────┐                                │
│    │  RED  │ Write a failing test           │
│    └───┬───┘                                │
│        │                                    │
│        ▼                                    │
│    ┌───────┐                                │
│    │ GREEN │ Write minimal code to pass     │
│    └───┬───┘                                │
│        │                                    │
│        ▼                                    │
│    ┌──────────┐                             │
│    │ REFACTOR │ Improve code, tests pass    │
│    └────┬─────┘                             │
│         │                                   │
│         └───────────────────────────────────┘
│
└─────────────────────────────────────────────┘
```

### 8.2 TDD Philosophy

**Why TDD?**

1. **Design Tool:** Tests force you to think about API design first
2. **Documentation:** Tests describe expected behavior
3. **Confidence:** Refactor fearlessly with test safety net
4. **Bug Prevention:** Catch regressions immediately
5. **Focus:** Work on one small piece at a time

**TDD Mantras:**

- "Write the test you'd want to read"
- "Make it work, make it right, make it fast"
- "Test behavior, not implementation"
- "If it's hard to test, the design might be wrong"

### 8.3 What to Test Per Layer

#### Domain Layer Tests

**Entities:**
- Value equality
- Business logic methods
- Validation rules

**Use Cases:**
- Correct repository method called
- Data transformation
- Error handling

**Testing Use Cases:**
```
// Arrange
when(() => mockRepository.getPokemonList(any()))
    .thenAnswer((_) async => Right(pokemonList));

// Act
final result = await useCase(params);

// Assert
expect(result, Right(pokemonList));
verify(() => mockRepository.getPokemonList(params)).called(1);
```

#### Data Layer Tests

**Models:**
- fromJson correctly parses JSON
- toJson produces expected JSON
- toEntity maps to domain entity correctly

**Repositories:**
- Returns data from remote when online
- Returns cached data when offline
- Caches data after successful fetch
- Handles exceptions and returns Failures

**Data Sources:**
- Correct HTTP method and URL
- Request headers/body correct
- Throws expected exceptions on errors

#### Presentation Layer Tests

**BLoCs:**
- Initial state correct
- Events produce expected states
- Error states handled
- All event types covered

**Using bloc_test:**
```
blocTest<PokemonListBloc, PokemonListState>(
  'emits [loading, loaded] when fetch succeeds',
  build: () {
    when(() => mockGetPokemonList(any()))
        .thenAnswer((_) async => Right(pokemonList));
    return PokemonListBloc(getPokemonList: mockGetPokemonList);
  },
  act: (bloc) => bloc.add(PokemonListEvent.started()),
  expect: () => [
    PokemonListState(status: Status.loading),
    PokemonListState(status: Status.success, pokemon: pokemonList),
  ],
);
```

**Widgets:**
- Renders correctly for each state
- User interactions dispatch correct events
- Loading indicators shown appropriately
- Error messages displayed

### 8.4 Mocking Strategy with Mocktail

**Creating Mocks:**
```
class MockPokemonRepository extends Mock implements PokemonRepository {}
class MockGetPokemonList extends Mock implements GetPokemonList {}
```

**Stubbing Behavior:**
```
// Success case
when(() => mock.method(any())).thenAnswer((_) async => result);

// Failure case
when(() => mock.method(any())).thenThrow(ServerException());
```

**Verifying Calls:**
```
verify(() => mock.method(expectedArg)).called(1);
verifyNever(() => mock.otherMethod(any()));
```

### 8.5 Test File Organization

```
test/
├── core/
│   ├── network/
│   │   └── network_info_test.dart
│   └── utils/
│       └── type_extensions_test.dart
│
├── features/
│   └── pokemon_list/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── pokemon_remote_datasource_test.dart
│       │   ├── models/
│       │   │   └── pokemon_model_test.dart
│       │   └── repositories/
│       │       └── pokemon_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── get_pokemon_list_test.dart
│       └── presentation/
│           ├── bloc/
│           │   └── pokemon_list_bloc_test.dart
│           └── widgets/
│               └── pokemon_card_test.dart
│
├── fixtures/
│   ├── pokemon_fixture.json
│   └── pokemon_list_fixture.json
│
└── helpers/
    ├── test_helper.dart
    └── pump_app.dart
```

### 8.6 Test Fixtures

Store JSON fixtures for consistent test data:

```
// test/fixtures/pokemon_fixture.json
{
  "id": 25,
  "name": "pikachu",
  "types": [{"type": {"name": "electric"}}],
  "sprites": {"front_default": "https://..."}
}
```

**Loading Fixtures:**
```
String fixture(String name) =>
    File('test/fixtures/$name').readAsStringSync();
```

### 8.7 Golden Tests

For complex UI, use golden tests to catch visual regressions:

```
testWidgets('PokemonCard golden test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: PokemonCard(pokemon: testPokemon)),
  );
  
  await expectLater(
    find.byType(PokemonCard),
    matchesGoldenFile('goldens/pokemon_card.png'),
  );
});
```

---

## 9. GitFlow Strategy

### 9.1 Branch Types

```
┌─────────────────────────────────────────────────────────────┐
│                         main                                 │
│  Production-ready code. Only release/ and hotfix/ merge here │
├─────────────────────────────────────────────────────────────┤
│                        develop                               │
│  Integration branch. Features merge here after review        │
├─────────────────────────────────────────────────────────────┤
│                    feature/xxx                               │
│  New features. Branch from develop, merge back to develop    │
├─────────────────────────────────────────────────────────────┤
│                    bugfix/xxx                                │
│  Bug fixes. Branch from develop, merge back to develop       │
├─────────────────────────────────────────────────────────────┤
│                    release/x.x.x                             │
│  Release prep. Branch from develop, merge to main & develop  │
├─────────────────────────────────────────────────────────────┤
│                    hotfix/xxx                                │
│  Urgent fixes. Branch from main, merge to main & develop     │
└─────────────────────────────────────────────────────────────┘
```

### 9.2 Branch Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/[ticket-id]-short-description` | `feature/PL-01-pokemon-list-ui` |
| Bugfix | `bugfix/[ticket-id]-short-description` | `bugfix/PL-15-pagination-crash` |
| Release | `release/[version]` | `release/1.0.0` |
| Hotfix | `hotfix/[ticket-id]-short-description` | `hotfix/URGENT-api-timeout` |

### 9.3 Workflow Examples

#### Starting a New Feature

```bash
# Ensure develop is up to date
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/PL-01-pokemon-list-ui

# Work on feature...
git add .
git commit -m "feat(pokemon-list): add grid layout component"

# Push and create PR
git push -u origin feature/PL-01-pokemon-list-ui
```

#### Completing a Feature

```bash
# Update feature branch with latest develop
git checkout feature/PL-01-pokemon-list-ui
git fetch origin
git rebase origin/develop

# Resolve any conflicts, then push
git push --force-with-lease

# Create PR to develop, get review, merge
```

#### Creating a Release

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/1.0.0

# Bump version, update changelog
# Test thoroughly

# Merge to main
git checkout main
git merge release/1.0.0 --no-ff
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main --tags

# Merge back to develop
git checkout develop
git merge release/1.0.0 --no-ff
git push origin develop

# Delete release branch
git branch -d release/1.0.0
```

### 9.4 Commit Message Conventions

Follow **Conventional Commits** specification:

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

**Types:**
| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change that neither fixes nor adds |
| `perf` | Performance improvement |
| `test` | Adding or correcting tests |
| `chore` | Maintain build, CI, etc. |

**Examples:**

```
feat(pokemon-list): implement infinite scroll pagination

Add pagination support to pokemon list with automatic
loading when scrolling near bottom of list.

Closes #PL-02
```

```
fix(battle): correct type effectiveness calculation

Fire was incorrectly super effective against water.
Updated type chart constant.

Fixes #BA-23
```

### 9.5 Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Feature
- [ ] Bug fix
- [ ] Refactor
- [ ] Documentation
- [ ] Other (describe)

## Related Issues
Closes #[issue number]

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] No warnings from analyzer

## Screenshots (if applicable)
[Add screenshots for UI changes]

## Testing Instructions
Steps to test this change
```

### 9.6 Merge Strategies

| Branch Type | Merge Strategy | Reason |
|-------------|----------------|--------|
| feature → develop | Squash merge | Clean history, one commit per feature |
| develop → release | Merge commit | Preserve complete history |
| release → main | Merge commit | Clear release points |
| hotfix → main/develop | Merge commit | Track emergency fixes |

---

## 10. CI/CD Pipeline

### 10.1 Pipeline Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    On Pull Request                           │
├─────────────────────────────────────────────────────────────┤
│  Format Check → Analyze → Test → Coverage → Build            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   On Merge to develop                        │
├─────────────────────────────────────────────────────────────┤
│  All above + Build Debug APK + Upload Artifact               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                  On Tag (Release)                            │
├─────────────────────────────────────────────────────────────┤
│  All above + Build Release APK/AAB + Deploy to Firebase      │
└─────────────────────────────────────────────────────────────┘
```

### 10.2 GitHub Actions Workflow: Pull Request

**File: `.github/workflows/pr_check.yml`**

```yaml
name: PR Check

on:
  pull_request:
    branches: [develop, main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
          cache: true
      
      - name: Install Dependencies
        run: flutter pub get
      
      - name: Generate Code
        run: dart run build_runner build --delete-conflicting-outputs
      
      - name: Check Formatting
        run: dart format --output=none --set-exit-if-changed .
      
      - name: Analyze Code
        run: flutter analyze --fatal-infos
      
      - name: Run Tests
        run: flutter test --coverage
      
      - name: Check Coverage
        uses: VeryGoodOpenSource/very_good_coverage@v2
        with:
          min_coverage: 80
      
      - name: Upload Coverage Report
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### 10.3 GitHub Actions Workflow: Develop Build

**File: `.github/workflows/develop_build.yml`**

```yaml
name: Develop Build

on:
  push:
    branches: [develop]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
          cache: true
      
      - name: Install Dependencies
        run: flutter pub get
      
      - name: Generate Code
        run: dart run build_runner build --delete-conflicting-outputs
      
      - name: Build Debug APK
        run: flutter build apk --debug
      
      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: debug-apk
          path: build/app/outputs/flutter-apk/app-debug.apk
```

### 10.4 GitHub Actions Workflow: Release

**File: `.github/workflows/release.yml`**

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
          cache: true
      
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Install Dependencies
        run: flutter pub get
      
      - name: Generate Code
        run: dart run build_runner build --delete-conflicting-outputs
      
      - name: Run Tests
        run: flutter test
      
      - name: Build Release APK
        run: flutter build apk --release
      
      - name: Build Release AAB
        run: flutter build appbundle --release
      
      - name: Upload to Firebase App Distribution
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_APP_ID }}
          serviceCredentialsFileContent: ${{ secrets.FIREBASE_CREDENTIAL }}
          groups: testers
          file: build/app/outputs/flutter-apk/app-release.apk
      
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            build/app/outputs/flutter-apk/app-release.apk
            build/app/outputs/bundle/release/app-release.aab
```

### 10.5 Quality Gates

| Gate | Threshold | Failure Action |
|------|-----------|----------------|
| Formatting | 100% compliant | Block merge |
| Static Analysis | 0 warnings/errors | Block merge |
| Test Coverage | ≥80% | Block merge |
| All Tests | 100% passing | Block merge |
| Build | Successful | Block merge |

### 10.6 Branch Protection Rules

Configure in GitHub repository settings:

**For `develop` branch:**
- Require pull request reviews (1 reviewer minimum)
- Require status checks to pass (PR Check workflow)
- Require branches to be up to date
- Include administrators in restrictions

**For `main` branch:**
- All of the above
- Require 2 reviewers
- Restrict who can push (only release managers)

---

## 11. Development Phases

### Phase 0: Project Setup (Week 1)

**Objectives:**
- Repository and tooling setup
- CI/CD pipeline operational
- Architecture scaffolding complete

**Tasks:**

| Task | Description | Deliverable |
|------|-------------|-------------|
| 0.1 | Initialize Flutter project | `flutter create` with org name |
| 0.2 | Configure FVM | `.fvm/fvm_config.json` |
| 0.3 | Add dependencies | `pubspec.yaml` complete |
| 0.4 | Setup linting | `analysis_options.yaml` |
| 0.5 | Create folder structure | All directories created |
| 0.6 | Configure DI | `injection_container.dart` |
| 0.7 | Setup GitHub Actions | All workflow files |
| 0.8 | Setup branch protection | GitHub settings |
| 0.9 | Create PR template | `.github/PULL_REQUEST_TEMPLATE.md` |

**Exit Criteria:**
- `flutter analyze` passes with no warnings
- CI pipeline runs on PR
- All team members can build locally

---

### Phase 1: Core Infrastructure (Week 2)

**Objectives:**
- Network layer operational
- Error handling established
- Base classes created

**Tasks:**

| Task | Description | Deliverable |
|------|-------------|-------------|
| 1.1 | Implement Dio client | Configured with interceptors |
| 1.2 | Create error types | `Exceptions` and `Failures` |
| 1.3 | Implement Either utilities | Error handling helpers |
| 1.4 | Create base UseCase | Abstract class for use cases |
| 1.5 | Create network info | Connectivity checking |
| 1.6 | Setup Hive | Local storage initialized |
| 1.7 | Write infrastructure tests | ≥80% coverage for core |

**Exit Criteria:**
- Can make API calls to PokéAPI
- Error handling works end-to-end
- All infrastructure code tested

---

### Phase 2: Pokédex List Feature (Weeks 3-4)

**Objectives:**
- Complete list feature with TDD
- Pagination working
- Search and filter functional

**TDD Cycle for Each Component:**

```
Day 1: Domain Layer
├── Write entity tests
├── Implement entity
├── Write use case tests
├── Implement use cases
└── Commit: "feat(pokemon-list): add domain layer"

Day 2: Data Layer
├── Write model tests (JSON parsing)
├── Implement models
├── Write remote datasource tests
├── Implement remote datasource
├── Write repository tests
├── Implement repository
└── Commit: "feat(pokemon-list): add data layer"

Day 3-4: Presentation Layer
├── Write BLoC tests
├── Implement BLoC
├── Write widget tests
├── Implement widgets
└── Commit: "feat(pokemon-list): add presentation layer"
```

**Exit Criteria:**
- List displays Pokémon from API
- Pagination loads more on scroll
- Search filters locally
- Type filter works
- All tests passing (≥80% coverage)

---

### Phase 3: Pokémon Detail Feature (Weeks 5-6)

**Objectives:**
- Complete detail view
- Stats visualization
- Evolution chain display

**Tasks:**

| Task | Description |
|------|-------------|
| 3.1 | Domain: PokemonDetail entity & use case |
| 3.2 | Domain: Evolution chain entities |
| 3.3 | Data: Detail model & datasource |
| 3.4 | Data: Species & evolution models |
| 3.5 | Presentation: Detail BLoC |
| 3.6 | Presentation: Stats bar chart |
| 3.7 | Presentation: Evolution chain widget |
| 3.8 | Presentation: Moves list |
| 3.9 | Integration: Navigate from list to detail |

**Exit Criteria:**
- Tapping list item opens detail
- All stats displayed correctly
- Evolution chain navigable
- Back navigation works
- All tests passing

---

### Phase 4: Battle Arena Feature (Weeks 7-9)

**Objectives:**
- Battle mechanics implemented
- Type effectiveness working
- Complete battle flow

**Tasks:**

| Task | Description |
|------|-------------|
| 4.1 | Domain: Battle entities (BattleState, Move, Turn) |
| 4.2 | Domain: Type effectiveness constants |
| 4.3 | Domain: Damage calculation use case |
| 4.4 | Domain: Battle orchestration use case |
| 4.5 | Presentation: Pokémon selection UI |
| 4.6 | Presentation: Battle BLoC |
| 4.7 | Presentation: Battle arena UI |
| 4.8 | Presentation: Turn log display |
| 4.9 | Presentation: Victory/defeat screen |

**Exit Criteria:**
- Can select two Pokémon
- Battle plays turn by turn
- Type effectiveness applied
- Winner determined correctly
- All tests passing

---

### Phase 5: Polish & Optimization (Weeks 10-12)

**Objectives:**
- Performance optimization
- UI polish
- Final documentation

**Tasks:**

| Task | Description |
|------|-------------|
| 5.1 | Performance profiling | Identify bottlenecks |
| 5.2 | Image caching optimization | Reduce memory usage |
| 5.3 | Add loading animations | Skeleton screens |
| 5.4 | Implement error states | User-friendly messages |
| 5.5 | Add empty states | When no data |
| 5.6 | Accessibility audit | Screen reader support |
| 5.7 | Write README | Project documentation |
| 5.8 | Create demo video | Portfolio piece |
| 5.9 | Final test coverage push | Target 85%+ |

**Exit Criteria:**
- No jank in UI (60fps)
- All edge cases handled
- Documentation complete
- Ready for portfolio

---

## 12. Quality Standards & Conventions

### 12.1 Dart Style Guide

Follow official Dart style with very_good_analysis:

**Naming Conventions:**

| Type | Convention | Example |
|------|------------|---------|
| Classes | UpperCamelCase | `PokemonListBloc` |
| Variables | lowerCamelCase | `pokemonName` |
| Constants | lowerCamelCase | `maxPokemonPerPage` |
| Files | snake_case | `pokemon_list_bloc.dart` |
| Folders | snake_case | `pokemon_list/` |
| Private | leading underscore | `_privateMethod` |

**Import Ordering:**

1. Dart SDK imports
2. Flutter imports
3. Package imports
4. Relative imports (project files)

Separate each group with a blank line.

### 12.2 Documentation Requirements

**Public APIs:** All public classes, methods, and properties must have dartdoc comments.

```dart
/// Fetches a paginated list of Pokémon.
///
/// Returns [Right] with [PokemonList] on success,
/// or [Left] with [Failure] on error.
///
/// Parameters:
/// - [page]: The page number to fetch (1-indexed)
/// - [limit]: Number of Pokémon per page (default: 20)
Future<Either<Failure, PokemonList>> getPokemonList({
  required int page,
  int limit = 20,
});
```

**Private Code:** Complex logic should have inline comments explaining "why", not "what".

### 12.3 Code Coverage Targets

| Layer | Minimum | Ideal |
|-------|---------|-------|
| Domain | 90% | 100% |
| Data | 85% | 95% |
| Presentation (BLoC) | 90% | 100% |
| Presentation (Widgets) | 70% | 85% |
| Overall | 80% | 90% |

### 12.4 Performance Benchmarks

| Metric | Target | Tool |
|--------|--------|------|
| Frame render time | <16ms | Flutter DevTools |
| App startup time | <3s | Timeline |
| Memory usage | <150MB | DevTools Memory |
| APK size | <50MB | Build output |
| API response handling | <500ms | Custom logging |

### 12.5 Accessibility Standards

- All images have semantic labels
- Touch targets ≥48x48 dp
- Color contrast ratio ≥4.5:1
- Screen reader tested
- Dynamic text scaling supported

---

## 13. API Integration Strategy

### 13.1 PokéAPI Overview

**Base URL:** `https://pokeapi.co/api/v2/`

PokéAPI is a RESTful API providing comprehensive Pokémon data. It's free, requires no authentication, and has fair use rate limiting.

### 13.2 Endpoints Required

| Endpoint | Purpose | Example |
|----------|---------|---------|
| `/pokemon` | List Pokémon | `?offset=0&limit=20` |
| `/pokemon/{id}` | Pokémon details | `/pokemon/25` |
| `/pokemon-species/{id}` | Species info, evolution | `/pokemon-species/25` |
| `/evolution-chain/{id}` | Evolution chain | `/evolution-chain/10` |
| `/type/{id}` | Type info | `/type/electric` |
| `/move/{id}` | Move details | `/move/thunderbolt` |
| `/ability/{id}` | Ability details | `/ability/static` |

### 13.3 Data Flow Example

```
User opens Pokémon #25 detail:

1. Request: GET /pokemon/25
   Response: Base stats, types, moves, abilities, sprites
   
2. Request: GET /pokemon-species/25
   Response: Evolution chain URL, flavor text
   
3. Request: GET /evolution-chain/10
   Response: Pichu → Pikachu → Raichu
   
4. Cache all responses in Hive
```

### 13.4 Model Mapping Strategy

**API Response → Model → Entity**

```
JSON (API)           Model (Data)           Entity (Domain)
──────────────────   ──────────────────     ──────────────────
{                    PokemonModel           Pokemon
  "id": 25,          - id: int              - id: int
  "name": "pikachu"  - name: String         - name: String
  "types": [...]     - types: List          - types: List<Type>
}                    + fromJson()           (no JSON dependency)
                     + toEntity()
```

### 13.5 Error Handling Strategy

| HTTP Status | Exception | Failure | User Message |
|-------------|-----------|---------|--------------|
| 200-299 | None | None | - |
| 400 | BadRequestException | RequestFailure | "Invalid request" |
| 404 | NotFoundException | NotFoundFailure | "Pokémon not found" |
| 429 | RateLimitException | RateLimitFailure | "Too many requests" |
| 500-599 | ServerException | ServerFailure | "Server error" |
| No internet | NetworkException | NetworkFailure | "No connection" |
| Timeout | TimeoutException | TimeoutFailure | "Request timeout" |

### 13.6 Caching Strategy

**Cache Layers:**

1. **Memory Cache:** Quick access during session
2. **Disk Cache (Hive):** Persist across sessions
3. **ETag/If-None-Match:** Validate cache freshness (if supported)

**Cache Invalidation:**

- Pokémon data: 7 days (data rarely changes)
- List data: 24 hours
- Manual refresh: User pull-to-refresh clears cache

---

## 14. Appendices

### 14.1 Glossary

| Term | Definition |
|------|------------|
| BLoC | Business Logic Component - state management pattern |
| Cubit | Simplified BLoC without explicit events |
| DTO | Data Transfer Object - data container for serialization |
| DI | Dependency Injection - providing dependencies externally |
| Entity | Core business object in domain layer |
| Either | Functional type representing success or failure |
| Freezed | Code generation for immutable classes |
| GitFlow | Branching model for version control |
| Repository | Abstraction over data sources |
| Use Case | Single business operation encapsulation |

### 14.2 Reference Documentation

**Flutter & Dart:**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/language)
- [Effective Dart](https://dart.dev/effective-dart)

**Architecture:**
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [ResoCoder Clean Architecture Tutorial](https://resocoder.com/flutter-clean-architecture-tdd/)

**State Management:**
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [bloc_test Package](https://pub.dev/packages/bloc_test)

**Packages:**
- [Freezed](https://pub.dev/packages/freezed)
- [Injectable](https://pub.dev/packages/injectable)
- [GetIt](https://pub.dev/packages/get_it)
- [Dio](https://pub.dev/packages/dio)
- [Retrofit](https://pub.dev/packages/retrofit)
- [Mocktail](https://pub.dev/packages/mocktail)

**API:**
- [PokéAPI Documentation](https://pokeapi.co/docs/v2)

### 14.3 Recommended Learning Path

**Before Starting:**
1. Complete Flutter official codelabs
2. Read "Clean Architecture" article by Uncle Bob
3. Watch ResoCoder's Clean Architecture series
4. Practice BLoC basics with counter/timer apps

**During Development:**
1. Read package documentation before using
2. Write tests before implementation
3. Review your own code before committing
4. Refactor when you learn better patterns

**After Completion:**
1. Write a retrospective document
2. Record a demo video
3. Write a blog post about learnings
4. Mentor others learning the same patterns

### 14.4 Common Pitfalls to Avoid

| Pitfall | Problem | Solution |
|---------|---------|----------|
| Layer violations | Importing data layer in domain | Use abstract repositories |
| Over-testing | Testing implementation details | Test behavior, not implementation |
| Premature optimization | Optimizing before profiling | Profile first, optimize second |
| Skipping tests | "I'll write tests later" | Write tests first (TDD) |
| Mega-BLoCs | One BLoC for entire app | One BLoC per feature/screen |
| Ignoring errors | Empty catch blocks | Handle every error explicitly |
| Copy-paste code | Duplicating code across features | Extract to shared utilities |

---

## Document Information

| Field | Value |
|-------|-------|
| Version | 1.0.0 |
| Created | December 2024 |
| Author | [Your Name] |
| Status | Draft |

---

*"The only way to go fast is to go well."* — Robert C. Martin