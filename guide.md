# PokéDex Pro: Step-by-Step Implementation Guide

> A Code-Free Walkthrough of Building an Enterprise-Grade Flutter Application

---

## How to Use This Guide

This guide is your implementation companion. It tells you **what to do**, **in what order**, and **why** — without showing code. The goal is to help you:

1. **Think through problems** before typing
2. **Understand the reasoning** behind each step
3. **Build muscle memory** for professional workflows
4. **Learn by doing**, not by copying

When you reach each step, you should:
- Read the step completely
- Research the specific implementation (docs, tutorials)
- Write the code yourself
- Test before moving on

---

## Table of Contents

1. [Phase 0: Project Setup](#phase-0-project-setup)
2. [Phase 1: Core Infrastructure](#phase-1-core-infrastructure)
3. [Phase 2: Pokédex List Feature](#phase-2-pokédex-list-feature)
4. [Phase 3: Pokémon Detail Feature](#phase-3-pokémon-detail-feature)
5. [Phase 4: Battle Arena Feature](#phase-4-battle-arena-feature)
6. [Phase 5: Polish & Optimization](#phase-5-polish--optimization)
7. [Troubleshooting Guide](#troubleshooting-guide)

---

## Phase 0: Project Setup

**Duration:** 1-2 days
**Goal:** Repository ready, CI/CD operational, architecture scaffolded

---

### Step 0.1: Environment Preparation

**What to do:**

1. Verify Flutter is installed by running the Flutter doctor command
2. Install FVM (Flutter Version Management) globally
3. Create a new directory for your project
4. Initialize FVM with the latest stable Flutter version
5. Run FVM use to activate that Flutter version for this project

**Why this matters:**

FVM ensures your project uses a consistent Flutter version. When you return to this project in 6 months, or when collaborating with others, everyone uses the exact same Flutter version. This prevents "works on my machine" problems.

**Verification:**

- Running Flutter from FVM should show the version you specified
- A `.fvm` folder should exist in your project root

---

### Step 0.2: Project Initialization

**What to do:**

1. Use Flutter create with your organization name (reverse domain notation)
2. Choose a descriptive project name (lowercase, underscores)
3. Delete the default counter app code in `main.dart`
4. Delete the default test file

**Decision point:**

Should you use Very Good CLI instead?

- **Yes if:** You want pre-configured Clean Architecture scaffolding
- **No if:** You want to build everything from scratch for learning

**Recommendation:** For maximum learning, create manually. You'll appreciate scaffolding tools more after doing it the hard way once.

**Verification:**

- Project builds and runs (shows blank screen)
- No analyzer warnings

---

### Step 0.3: Git Repository Setup

**What to do:**

1. Initialize git in the project root
2. Create a `.gitignore` file appropriate for Flutter (Flutter's default is good, but verify it includes `.fvm/flutter_sdk`)
3. Make your initial commit with message: `chore: initial project setup`
4. Create a repository on GitHub (private or public, your choice)
5. Add the remote origin
6. Push to GitHub
7. Create a `develop` branch from `main`
8. Push `develop` to GitHub
9. Set `develop` as your default working branch

**Why this matters:**

Starting with proper GitFlow from day one builds good habits. The `main` branch will only contain release-ready code. All development happens on `develop` or feature branches.

**Verification:**

- GitHub shows both `main` and `develop` branches
- You're currently on `develop` locally

---

### Step 0.4: Dependencies Configuration

**What to do:**

Open `pubspec.yaml` and add dependencies in these categories:

**State Management:**
- flutter_bloc (for BLoC pattern)
- bloc (core library)

**Code Generation:**
- freezed_annotation (for Freezed)
- json_annotation (for JSON serialization)
- injectable (for dependency injection)

**Networking:**
- dio (HTTP client)
- retrofit (type-safe API)

**Local Storage:**
- hive (local database)
- hive_flutter (Flutter integration)

**Functional Programming:**
- dartz OR fpdart (for Either type)

**Utilities:**
- equatable (value equality, optional with Freezed)
- connectivity_plus (network status)

**Dev Dependencies:**
- build_runner (runs code generation)
- freezed (generates immutable classes)
- json_serializable (generates JSON code)
- injectable_generator (generates DI code)
- retrofit_generator (generates API code)
- hive_generator (generates Hive adapters)
- flutter_test (built-in)
- bloc_test (BLoC testing)
- mocktail (mocking)
- very_good_analysis (lint rules)

**Why this matters:**

Adding all dependencies upfront prevents version conflicts later. Dependencies are resolved together, so adding them incrementally can cause compatibility issues.

**Verification:**

- `flutter pub get` succeeds with no errors
- No version resolution conflicts

---

### Step 0.5: Analysis Options Configuration

**What to do:**

1. Create or modify `analysis_options.yaml`
2. Include the very_good_analysis package
3. Optionally add project-specific rule overrides (but be conservative — the strict rules are there for good reason)

**Common rules to consider relaxing (only if needed):**
- `public_member_api_docs` — if you find documenting everything too burdensome initially
- `lines_longer_than_80_chars` — if you prefer 100 or 120

**Why this matters:**

Strict linting catches bugs early and enforces consistency. It's easier to start strict and relax than to add strictness to a messy codebase.

**Verification:**

- `flutter analyze` runs (may show issues in generated code locations that don't exist yet — that's okay)

---

### Step 0.6: Folder Structure Creation

**What to do:**

Create the following directory structure inside `lib/`:

```
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── usecases/
│   └── utils/
├── features/
│   ├── pokemon_list/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   ├── pokemon_detail/
│   │   └── [same structure]
│   └── battle_arena/
│       └── [same structure]
└── main.dart
```

Also create test directory structure mirroring `lib/`:

```
test/
├── core/
├── features/
├── fixtures/
└── helpers/
```

**Why this matters:**

Creating folders upfront:
- Forces you to think about architecture before coding
- Makes it easy to find files later
- Prevents the temptation to dump everything in one place

**Pro tip:** Create a `.gitkeep` file in each empty folder so git tracks them. Remove these as you add real files.

**Verification:**

- All directories exist
- Git status shows new directories (via .gitkeep files)

---

### Step 0.7: Dependency Injection Setup

**What to do:**

1. Create `injection_container.dart` in `lib/`
2. Create a function that initializes GetIt
3. Add the `@InjectableInit` annotation for Injectable
4. Create a placeholder configureDependencies function
5. Run build_runner to generate the injection config

**Mental model:**

Think of GetIt as a box where you register all your dependencies. When any part of your app needs a dependency, it asks the box for it. Injectable automatically fills the box based on annotations.

**Why this matters:**

Setting up DI early means:
- You can register dependencies as you build them
- Testing is easier (swap real implementations for mocks)
- No manual dependency threading through constructors

**Verification:**

- Build runner generates `injection_container.config.dart`
- No errors when importing and calling configureDependencies

---

### Step 0.8: GitHub Actions Setup

**What to do:**

Create three workflow files in `.github/workflows/`:

**1. PR Check Workflow (`pr_check.yml`):**
- Trigger: On pull request to develop or main
- Steps: Checkout → Setup Flutter → Get dependencies → Generate code → Format check → Analyze → Test with coverage → Coverage threshold check

**2. Develop Build Workflow (`develop_build.yml`):**
- Trigger: On push to develop
- Steps: All PR checks → Build debug APK → Upload as artifact

**3. Release Workflow (`release.yml`):**
- Trigger: On tag push (v*)
- Steps: All checks → Build release APK/AAB → Create GitHub release → Optionally deploy to Firebase

**Key configuration points:**
- Use `subosito/flutter-action` for Flutter setup
- Enable caching for faster runs
- Use `--delete-conflicting-outputs` with build_runner
- Set coverage threshold to 80%

**Why this matters:**

CI/CD from day one means:
- Every PR is automatically validated
- You can't accidentally merge broken code
- Builds are reproducible
- You develop the habit of keeping tests passing

**Verification:**

- Push a commit to trigger workflows
- Workflows appear in GitHub Actions tab
- Initial run may fail (no tests yet) — that's expected

---

### Step 0.9: Branch Protection Rules

**What to do:**

In GitHub repository settings → Branches:

**For `develop`:**
1. Require pull request before merging
2. Require at least 1 approval (or 0 if solo, but keep the PR requirement)
3. Require status checks to pass (select your PR check workflow)
4. Require branches to be up to date before merging

**For `main`:**
1. All of the above
2. Require linear history (optional, enforces rebase/squash)
3. Restrict who can push directly (only through PRs)

**Why this matters:**

Branch protection prevents accidents:
- No force-pushing over history
- No bypassing tests
- Code review becomes mandatory (even reviewing your own code helps)

**Verification:**

- Try pushing directly to main — it should fail
- Creating a PR shows required status checks

---

### Step 0.10: PR Template and Documentation

**What to do:**

1. Create `.github/PULL_REQUEST_TEMPLATE.md` with sections for:
   - Description of changes
   - Type of change (feature/bugfix/refactor)
   - Related issues
   - Checklist (tests, docs, self-review)
   - Screenshots (if UI changes)

2. Create initial `README.md` with:
   - Project name and description
   - Setup instructions
   - Architecture overview (brief)
   - "Work in Progress" notice

3. Create `CHANGELOG.md` with initial entry

**Why this matters:**

Templates ensure consistency and prevent forgetting important information. Good documentation helps future-you (and others) understand the project.

**Verification:**

- Creating a new PR shows your template
- README renders correctly on GitHub

---

### Step 0.11: First Feature Branch and PR

**What to do:**

1. Create branch: `feature/phase-0-project-setup`
2. Commit all Phase 0 work with appropriate messages:
   - `chore: configure dependencies`
   - `chore: setup folder structure`
   - `chore: configure dependency injection`
   - `ci: add GitHub Actions workflows`
3. Push branch and create PR to develop
4. Review your own PR (look for issues)
5. Merge using squash merge
6. Delete the feature branch

**Why this matters:**

Practicing the full PR workflow on setup work builds the habit. By the time you're writing feature code, the workflow will be automatic.

**Verification:**

- PR shows all status checks passing (or expected failures)
- Develop branch contains all setup work
- Feature branch is deleted

---

### Phase 0 Completion Checklist

Before moving to Phase 1, verify:

- [ ] Flutter project builds and runs
- [ ] FVM configured with Flutter version
- [ ] All dependencies in pubspec.yaml
- [ ] Analyzer passes (very_good_analysis)
- [ ] Folder structure created (lib/ and test/)
- [ ] GetIt/Injectable configured
- [ ] GitHub Actions workflows exist
- [ ] Branch protection rules active
- [ ] PR template created
- [ ] Phase 0 merged to develop via PR

---

## Phase 1: Core Infrastructure

**Duration:** 3-4 days
**Goal:** Network layer, error handling, and base classes operational

---

### Step 1.1: Define Error Types

**What to do:**

1. In `core/error/`, create two files: one for exceptions, one for failures

2. **Exceptions** (thrown in data layer):
   - ServerException — API returned error status
   - CacheException — Local storage operation failed
   - NetworkException — No internet connection

3. **Failures** (returned from repositories):
   - ServerFailure — Corresponds to ServerException
   - CacheFailure — Corresponds to CacheException
   - NetworkFailure — Corresponds to NetworkException

**Mental model:**

- **Exceptions** are thrown — they're emergencies that interrupt normal flow
- **Failures** are values — they're expected outcomes that we handle gracefully

The repository catches exceptions and converts them to failures. The rest of the app only deals with failures.

**Why this separation?**

Clean Architecture wants the domain layer to be pure. Exceptions are a Dart/language concept. Failures are a domain concept. The domain doesn't care HOW something failed, just THAT it failed and WHAT KIND of failure.

**Design decision:**

Should failures contain messages?

- **Option A:** Generic failures with no message — UI provides user-friendly messages
- **Option B:** Failures contain error messages — More information available
- **Recommendation:** Option A for user-facing text, but failures can contain technical details for logging

**Verification:**

- Files created, no analyzer errors
- Write unit tests for any logic in these classes

---

### Step 1.2: Create Either Utilities

**What to do:**

1. If using dartz/fpdart, familiarize yourself with the Either type
2. Create helper extensions or typedefs in `core/utils/`
3. Define a standard Result type: `typedef Result<T> = Either<Failure, T>`

**Key Either concepts to understand:**

- `Right` = Success case (think "right" as in "correct")
- `Left` = Failure case
- `fold()` = Handle both cases
- `map()` = Transform success value
- `flatMap()`/`bind()` = Chain operations that return Either

**Practice exercises:**

Before using Either in real code, practice:
1. Creating Right and Left values
2. Using fold to handle both cases
3. Chaining multiple Either operations
4. Converting nullable values to Either

**Why this matters:**

Either forces explicit error handling. You literally cannot access the success value without also handling the failure case. This eliminates forgotten error handling.

**Verification:**

- You can explain Either to someone else
- Write small test cases demonstrating Either usage

---

### Step 1.3: Create Base UseCase Class

**What to do:**

1. In `core/usecases/`, create an abstract UseCase class
2. The class should be generic with two type parameters: return type and params type
3. Define a call method that takes params and returns `Future<Either<Failure, ReturnType>>`
4. Create a NoParams class for use cases that don't need parameters

**Design pattern:**

This is the Command Pattern. Each use case is a command that can be executed. The uniform interface makes use cases interchangeable and testable.

**Why abstract?**

All use cases share the same signature. This allows:
- BLoCs to depend on use case abstractions
- Easy mocking in tests
- Consistent invocation pattern

**Verification:**

- UseCase class compiles
- You understand how generics work here

---

### Step 1.4: Network Info Implementation

**What to do:**

1. In `core/network/`, create an abstract NetworkInfo class
2. Define a method to check if device is connected
3. Create implementation using connectivity_plus package
4. Register with GetIt (abstract type → concrete implementation)

**Testing consideration:**

Create the abstract class specifically so you can mock it in tests. The actual implementation uses platform channels (hardware), which can't run in tests.

**Why this matters:**

The repository uses NetworkInfo to decide:
- Should I try the API or go straight to cache?
- If API fails, is it a network issue or server issue?

**Verification:**

- NetworkInfo returns connection status
- Write tests using mock NetworkInfo

---

### Step 1.5: API Constants

**What to do:**

1. In `core/constants/`, create API constants file
2. Define base URL: `https://pokeapi.co/api/v2/`
3. Define endpoint paths as constants
4. Define timeout durations
5. Define pagination defaults (limit = 20)

**Best practice:**

Never hardcode URLs or magic numbers in business logic. Constants should be:
- Centralized (one place to change)
- Named (self-documenting)
- Typed (compile-time safety)

**Verification:**

- Constants are accessible from network layer
- No hardcoded strings in other files

---

### Step 1.6: Dio Client Configuration

**What to do:**

1. In `core/network/`, create API client configuration
2. Configure Dio with:
   - Base URL from constants
   - Timeout settings (connect, receive, send)
   - Default headers (Content-Type: application/json)
3. Add interceptors:
   - Logging interceptor (for debug builds only)
   - Error interceptor (transform Dio errors to your exceptions)
4. Register Dio instance with GetIt as singleton

**Interceptor chain:**

Request → Logging → [Network] → Error Handling → Logging → Response

**Why interceptors?**

Interceptors are middleware. They allow:
- Centralized logging
- Automatic token refresh (if you add auth later)
- Consistent error transformation
- Request/response modification

**Verification:**

- Dio is registered in GetIt
- Making a test request to PokéAPI succeeds
- Errors are transformed to your exception types

---

### Step 1.7: Hive Initialization

**What to do:**

1. Initialize Hive in your app startup (main function)
2. Create a helper function that:
   - Initializes Hive with Flutter
   - Opens required boxes (you'll add more later)
3. Consider creating box name constants
4. Register Hive boxes with GetIt

**Mental model:**

Hive boxes are like tables in a database. Each box stores related data:
- `pokemonBox` — Cached Pokémon data
- `settingsBox` — User preferences

**Why initialize in main?**

Hive requires async initialization. Doing it in main ensures it's ready before any widget builds.

**Verification:**

- App starts without Hive errors
- Can open and close a test box

---

### Step 1.8: Write Infrastructure Tests

**What to do:**

1. Create test files mirroring your core/ structure
2. Test NetworkInfo:
   - Returns true when connected
   - Returns false when disconnected
3. Test error transformations:
   - Dio errors convert to correct exception types
4. Test any utility functions

**Testing philosophy:**

Infrastructure is the foundation. Bugs here affect everything. Test thoroughly even though the code seems simple.

**Verification:**

- All core/ code has corresponding tests
- Tests pass locally and in CI

---

### Step 1.9: First Integration Check

**What to do:**

1. Create a simple temporary test in main:
   - Initialize DI
   - Get Dio from GetIt
   - Make request to `/pokemon?limit=5`
   - Print result
2. Verify the entire pipeline works
3. Delete the temporary code after verification

**Why this sanity check?**

Before building features, confirm:
- DI is wired correctly
- Network layer works
- PokéAPI is accessible
- Error handling catches issues

**Verification:**

- You see Pokémon data in debug console
- Turning off internet shows NetworkException
- Invalid URL shows appropriate error

---

### Step 1.10: Phase 1 PR

**What to do:**

1. Create branch: `feature/phase-1-core-infrastructure`
2. Commit with meaningful messages:
   - `feat(core): add error types and failures`
   - `feat(core): implement network info`
   - `feat(core): configure Dio client`
   - `feat(core): initialize Hive storage`
   - `test(core): add infrastructure tests`
3. Create PR, review, merge to develop

**Verification:**

- CI passes with tests
- Coverage meets threshold (or close to it)
- No analyzer warnings

---

### Phase 1 Completion Checklist

- [ ] Exception and Failure types defined
- [ ] Either utilities/typedefs created
- [ ] Base UseCase class implemented
- [ ] NetworkInfo implemented and registered
- [ ] API constants defined
- [ ] Dio configured with interceptors
- [ ] Hive initialized
- [ ] All infrastructure code tested
- [ ] Phase 1 merged to develop

---

## Phase 2: Pokédex List Feature

**Duration:** 5-7 days
**Goal:** Complete list feature with TDD, pagination, search, and filtering

---

### Understanding the TDD Workflow

For each component, you'll follow this cycle:

```
1. Write a failing test
2. See it fail (RED)
3. Write minimum code to pass
4. See it pass (GREEN)
5. Refactor if needed
6. Repeat
```

**Important:** Resist the urge to write more code than needed to pass the test. Even if you know you'll need more, wait for a test to drive it.

---

### Step 2.1: Domain — Pokemon Entity

**What to do:**

1. **Write test first:**
   - Test that two Pokemon with same ID are equal
   - Test that Pokemon has required properties

2. **Create the entity:**
   - In `domain/entities/`, create Pokemon class
   - Properties: id, name, imageUrl, types
   - Use Freezed for immutability

3. **Run build_runner** to generate Freezed code

4. **Verify tests pass**

**Entity design decisions:**

- Should types be a List<String> or List<PokemonType> enum?
  - **Recommendation:** Create a PokemonType enum. Type-safety catches typos.

- How much data should the entity have?
  - **For list:** Minimal (id, name, image, types)
  - **For detail:** Everything (stats, moves, abilities)
  - **Recommendation:** Create separate entities: Pokemon (list) and PokemonDetail (detail)

**Why entity first?**

Entities are the core of your domain. Everything else depends on them. Starting here ensures you think about your domain model before implementation details.

**Verification:**

- Entity tests pass
- Freezed generates copyWith, ==, hashCode

---

### Step 2.2: Domain — Pokemon Repository Contract

**What to do:**

1. **Think about what operations you need:**
   - Get paginated list of Pokémon
   - Search Pokémon by name
   - Maybe: Get Pokémon by type

2. **Create abstract repository:**
   - In `domain/repositories/`, create abstract PokemonRepository
   - Define method signatures returning `Future<Either<Failure, ...>>`

3. **No tests needed** — this is just an interface

**Method signature design:**

```
getPokemonList({required int page, int limit = 20})
  → Future<Either<Failure, PokemonListResponse>>

searchPokemon({required String query})
  → Future<Either<Failure, List<Pokemon>>>
```

**Why abstract?**

The domain layer defines WHAT operations exist, not HOW they're implemented. The data layer provides the implementation.

**Verification:**

- Repository interface compiles
- Methods return Either types

---

### Step 2.3: Domain — GetPokemonList Use Case

**What to do:**

1. **Write tests first:**
   - Test: Use case calls repository with correct parameters
   - Test: Use case returns repository result unchanged
   - Test: Use case propagates failures

2. **Create the use case:**
   - Extend your base UseCase class
   - Inject repository (abstract type) via constructor
   - Call repository method in the call() implementation

3. **Register with Injectable** using `@injectable` annotation

**Use case parameters:**

Create a Params class (or use Freezed) containing:
- page: int
- limit: int (with default)

**Why test this?**

The use case seems trivial — it just calls the repository. But testing ensures:
- Correct parameter passing
- Proper error propagation
- The contract is maintained

**Verification:**

- Tests pass with mock repository
- Use case registered in GetIt

---

### Step 2.4: Domain — SearchPokemon Use Case

**What to do:**

1. **Write tests first:**
   - Test: Calls repository with query
   - Test: Returns matching Pokémon
   - Test: Handles empty results
   - Test: Propagates failures

2. **Create the use case:**
   - Similar structure to GetPokemonList
   - Parameters: query string

**Design decision:**

Should search be server-side or client-side?

- **Server-side:** PokéAPI doesn't have great search — you'd fetch all and filter
- **Client-side:** Fetch all (or cached list), filter locally
- **Recommendation:** Client-side filtering for this project. Fetch list once, filter in memory.

If client-side, the use case might need to call GetPokemonList internally or depend on a cached list.

**Verification:**

- Tests pass
- Search logic is correct

---

### Step 2.5: Data — Pokemon Model

**What to do:**

1. **Write tests first:**
   - Test: fromJson creates model from valid JSON
   - Test: fromJson handles missing optional fields
   - Test: toJson produces correct JSON
   - Test: toEntity converts to domain entity

2. **Create the model:**
   - In `data/models/`, create PokemonModel
   - Use JsonSerializable annotation
   - Create toEntity() method

3. **Run build_runner** for JSON code generation

**Model vs Entity:**

- **Model:** Knows about JSON, has fromJson/toJson, belongs to data layer
- **Entity:** Pure domain object, no serialization, belongs to domain layer

The model "wraps" API-specific details. If the API changes, you only change the model.

**JSON structure from PokéAPI:**

Study the actual API response:
```
GET /pokemon?limit=20

{
  "count": 1281,
  "next": "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
  "previous": null,
  "results": [
    {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"}
  ]
}
```

Note: This only gives name and URL. You need to call each URL for details, OR use a different approach.

**Strategy options:**

1. **Multiple calls:** Fetch list, then fetch each Pokémon detail
2. **Bulk fetch:** Use /pokemon/{id} for first N Pokémon
3. **Hybrid:** Fetch list URLs, then batch detail requests

**Recommendation:** Start with option 2 for simplicity — fetch /pokemon/1, /pokemon/2, etc.

**Verification:**

- Model tests pass
- JSON parsing works with real API response structure

---

### Step 2.6: Data — Pokemon Remote Data Source

**What to do:**

1. **Write tests first:**
   - Test: Successful API call returns model list
   - Test: Server error throws ServerException
   - Test: Network error throws appropriate exception

2. **Create abstract data source:**
   - Define method signatures
   - This allows mocking in repository tests

3. **Create implementation:**
   - Use Retrofit annotation OR manual Dio calls
   - If Retrofit: Define API interface with annotations
   - Handle errors and throw exceptions

**Retrofit approach:**

- Cleaner code
- Code generation
- Type-safe

**Manual Dio approach:**

- More control
- No additional code generation
- Better for learning Dio

**Recommendation:** Try manual Dio first to understand it, then refactor to Retrofit.

**Error handling:**

Wrap API calls in try-catch:
- DioException → ServerException or NetworkException
- Other errors → Rethrow or generic exception

**Verification:**

- Data source tests pass with mock Dio
- Real API call works (temporary test)

---

### Step 2.7: Data — Pokemon Local Data Source

**What to do:**

1. **Write tests first:**
   - Test: cachePokemonList stores data
   - Test: getLastPokemonList retrieves cached data
   - Test: getLastPokemonList throws CacheException if no cache

2. **Create abstract class and implementation:**
   - Use Hive box for storage
   - Store models as JSON strings or use HiveObject

**Caching strategy:**

- Store entire list response? Or individual Pokémon?
- **Recommendation:** Store list response with timestamp for cache invalidation

**Hive considerations:**

- Use TypeAdapters for complex objects OR store as JSON strings
- JSON strings are simpler but slower for large data

**Verification:**

- Cache tests pass
- Data persists across method calls

---

### Step 2.8: Data — Pokemon Repository Implementation

**What to do:**

1. **Write tests first:**
   - Test: When online, fetches from remote
   - Test: When online, caches result
   - Test: When offline, returns cached data
   - Test: When offline and no cache, returns NetworkFailure
   - Test: When remote fails, returns ServerFailure

2. **Create implementation:**
   - Implement the abstract repository from domain layer
   - Inject: remote data source, local data source, network info
   - Check network status before remote call
   - Cache successful responses
   - Convert exceptions to failures

**Repository pattern:**

```
if (network is connected) {
  try {
    data = remote.getData()
    local.cacheData(data)
    return Right(data.toEntity())
  } catch (e) {
    return Left(ServerFailure())
  }
} else {
  try {
    data = local.getCachedData()
    return Right(data.toEntity())
  } catch (e) {
    return Left(NetworkFailure())
  }
}
```

**Register with Injectable:**

Use `@LazySingleton(as: PokemonRepository)` to bind implementation to abstract type.

**Verification:**

- All repository tests pass
- Repository registered in GetIt with abstract type

---

### Step 2.9: Presentation — PokemonListState

**What to do:**

1. **Design the state:**
   - What data does the UI need?
   - What loading/error states exist?

2. **Create with Freezed:**

   **Option A: Single state with status enum:**
   - status (initial/loading/success/failure)
   - pokemonList (empty when loading)
   - currentPage
   - hasMorePages
   - searchQuery
   - failure (null when no error)

   **Option B: Union types:**
   - PokemonListInitial
   - PokemonListLoading
   - PokemonListLoaded(list, page, hasMore)
   - PokemonListError(failure)

**Recommendation:** Option A is more practical for complex UIs. Option B is cleaner for simple states.

3. **Run build_runner**

**Verification:**

- State compiles
- Can create instances of all states/status values

---

### Step 2.10: Presentation — PokemonListEvent

**What to do:**

1. **Identify user actions:**
   - App starts / Screen opens → Initial fetch
   - User scrolls to bottom → Load more
   - User pulls to refresh → Refresh list
   - User types in search → Search query changed
   - User selects type filter → Filter changed

2. **Create with Freezed:**
   - started() — Initial load
   - refreshed() — Pull to refresh
   - nextPageRequested() — Pagination
   - searchQueryChanged(String query) — Search
   - filterChanged(PokemonType? type) — Filter

**Event naming:**

Past tense ("started", "refreshed") describes what happened.
This is semantic — events represent things that occurred.

**Verification:**

- All events compile
- Events have necessary parameters

---

### Step 2.11: Presentation — PokemonListBloc

**What to do:**

1. **Write tests first (using bloc_test):**
   - Test: Initial state is correct
   - Test: Started event triggers fetch and emits loading → loaded
   - Test: Started event with failure emits loading → error
   - Test: NextPageRequested loads more and appends
   - Test: SearchQueryChanged filters the list
   - Test: Refreshed clears and reloads

2. **Create the BLoC:**
   - Extend Bloc<PokemonListEvent, PokemonListState>
   - Inject use cases via constructor
   - Register event handlers for each event type

3. **Register with Injectable:**
   - Use `@injectable` (new instance each time, BLoCs shouldn't be singletons)

**Event handler implementation:**

```
on<_Started>((event, emit) async {
  emit(state.copyWith(status: loading))
  final result = await getPokemonList(params)
  result.fold(
    (failure) => emit(state.copyWith(status: failure, failure: failure)),
    (data) => emit(state.copyWith(status: success, pokemonList: data)),
  )
})
```

**Debouncing search:**

Use EventTransformer to debounce searchQueryChanged:
- Wait 300ms after user stops typing
- Cancel previous search if new input arrives

**Verification:**

- All BLoC tests pass
- BLoC registered in GetIt

---

### Step 2.12: Presentation — Pokemon List Page

**What to do:**

1. **Write widget tests first:**
   - Test: Shows loading indicator in loading state
   - Test: Shows list in loaded state
   - Test: Shows error message in error state
   - Test: Tapping item dispatches selection event (for navigation)

2. **Create the page:**
   - Use BlocProvider to provide the BLoC
   - Use BlocBuilder to rebuild on state changes
   - Dispatch Started event in initState or via BlocListener

3. **Handle different states:**
   - Initial: Nothing or prompt
   - Loading: CircularProgressIndicator or Skeleton
   - Success: ListView/GridView
   - Failure: Error message with retry button

**Widget structure:**

```
PokemonListPage (provides BLoC)
└── BlocBuilder
    └── switch on status:
        - loading → LoadingWidget
        - success → PokemonGrid
        - failure → ErrorWidget
```

**Pagination UI:**

- Detect when user scrolls near bottom
- Dispatch NextPageRequested
- Show loading indicator at bottom while loading more

**Verification:**

- Widget tests pass with mock BLoC
- Screen renders all states correctly

---

### Step 2.13: Presentation — Pokemon Card Widget

**What to do:**

1. **Write widget tests:**
   - Test: Displays Pokémon name
   - Test: Displays Pokémon image
   - Test: Displays type badges
   - Test: Calls onTap when tapped

2. **Create the widget:**
   - Accept Pokemon entity and onTap callback
   - Display image, name, types
   - Make tappable (InkWell/GestureDetector)

**Design considerations:**

- Card vs Container?
- Image loading and error states
- Type badge colors (create a color map)

**Verification:**

- Card renders correctly
- Interactions work

---

### Step 2.14: Presentation — Search and Filter UI

**What to do:**

1. **Search bar:**
   - TextField with search decoration
   - onChanged dispatches SearchQueryChanged event
   - Clear button when text present

2. **Filter chips:**
   - Horizontal scrollable list of type chips
   - Tapping chip dispatches FilterChanged event
   - Selected chip shows different style

3. **Write widget tests** for both components

**UX considerations:**

- Debounce in BLoC, not in TextField
- Show "No results" when search/filter returns empty
- Clear filters button when filters active

**Verification:**

- Search and filter work together
- UI responds to all combinations

---

### Step 2.15: Integration and Navigation

**What to do:**

1. **Setup navigation:**
   - Choose: Navigator 2.0, GoRouter, or basic Navigator
   - **Recommendation:** GoRouter for simplicity with deep linking

2. **Configure routes:**
   - `/` or `/pokemon` → PokemonListPage
   - `/pokemon/:id` → PokemonDetailPage (placeholder for now)

3. **Wire up tap navigation:**
   - Tapping PokemonCard navigates to detail route

**Verification:**

- Tapping card navigates (even to placeholder)
- Back navigation works

---

### Step 2.16: Phase 2 PR

**What to do:**

1. Create branch: `feature/phase-2-pokemon-list`
2. Make atomic commits throughout development
3. Create PR, review all changes
4. Ensure CI passes
5. Merge to develop

**Commit examples:**
- `feat(pokemon-list): add domain entities and use cases`
- `feat(pokemon-list): implement data layer with caching`
- `feat(pokemon-list): add BLoC with pagination support`
- `feat(pokemon-list): create list and card UI components`
- `test(pokemon-list): add comprehensive tests`

---

### Phase 2 Completion Checklist

- [ ] Pokemon entity with Freezed
- [ ] Repository contract in domain layer
- [ ] GetPokemonList use case with tests
- [ ] PokemonModel with JSON serialization
- [ ] Remote data source (API calls)
- [ ] Local data source (caching)
- [ ] Repository implementation with tests
- [ ] PokemonListBloc with all events
- [ ] List page with all states
- [ ] Pokemon card widget
- [ ] Search functionality
- [ ] Type filter functionality
- [ ] Pagination (infinite scroll)
- [ ] Navigation to detail (placeholder)
- [ ] All tests passing (≥80% coverage)
- [ ] Phase 2 merged to develop

---

## Phase 3: Pokémon Detail Feature

**Duration:** 4-5 days
**Goal:** Complete detail view with stats, evolutions, moves

---

### Step 3.1: Understand the Data Requirements

**What to do:**

1. **Study PokéAPI endpoints:**
   - `/pokemon/{id}` — Stats, types, moves, abilities, sprites
   - `/pokemon-species/{id}` — Evolution chain URL, flavor text
   - `/evolution-chain/{id}` — Full evolution chain

2. **Map data relationships:**
   - Pokemon detail requires 1 API call
   - Evolution chain requires 2 additional calls (species → evolution chain)

3. **Plan your entities:**
   - PokemonDetail — Full Pokémon information
   - PokemonStat — Individual stat (name, value)
   - PokemonMove — Move info
   - PokemonAbility — Ability info
   - EvolutionChain — Chain of evolutions

**Why understand first?**

The detail feature is more complex. Planning prevents:
- Multiple refactors
- Unnecessary API calls
- Tangled data structures

---

### Step 3.2: Domain — PokemonDetail Entity

**What to do:**

1. **Write tests** for entity equality and properties

2. **Create entity with properties:**
   - All properties from Pokemon (id, name, types, imageUrl)
   - stats: List<PokemonStat>
   - moves: List<PokemonMove>
   - abilities: List<PokemonAbility>
   - height, weight
   - sprites (front, back, shiny variants)

3. **Create supporting entities:**
   - PokemonStat: name, baseStat, effort
   - PokemonMove: name, power, accuracy, type
   - PokemonAbility: name, description, isHidden

**Design decision:**

How much move data to include?
- **Minimal:** Just move names (fast, less API calls)
- **Full:** All move details (slow, many API calls)
- **Recommendation:** Start minimal, fetch details on demand if needed

---

### Step 3.3: Domain — Evolution Entities

**What to do:**

1. **Create EvolutionChain entity:**
   - Represents a tree structure
   - Each node: species name, evolution details, evolvesTo list

2. **Create EvolutionNode entity:**
   - speciesName
   - speciesId (extract from URL)
   - evolutionDetails (level, item, trigger)
   - evolvesTo: List<EvolutionNode>

**Challenge:**

PokéAPI returns evolution as a nested structure. You need to:
- Parse the nested JSON
- Convert to your flat or tree entity
- Handle branching evolutions (Eevee)

**Verification:**

- Entities can represent: linear chain (Bulbasaur), branching (Eevee), no evolution (Ditto)

---

### Step 3.4: Domain — Repository & Use Cases

**What to do:**

1. **Update PokemonRepository** (or create PokemonDetailRepository):
   - getPokemonDetail(int id)
   - getEvolutionChain(int speciesId)

2. **Create GetPokemonDetail use case:**
   - Takes Pokemon ID
   - Returns PokemonDetail

3. **Create GetEvolutionChain use case:**
   - Takes species ID
   - Returns EvolutionChain

4. **Write tests** for each use case

**Consider combining:**

Should one use case fetch both detail and evolution?
- **Separate:** More flexible, can load evolution lazily
- **Combined:** Single call, simpler BLoC logic
- **Recommendation:** Separate for flexibility

---

### Step 3.5: Data — Detail Model and Data Source

**What to do:**

1. **Create PokemonDetailModel:**
   - Matches API response structure
   - fromJson, toEntity methods
   - Write JSON parsing tests

2. **Create EvolutionChainModel:**
   - Parse nested evolution structure
   - Convert to domain entity
   - This is complex — take your time

3. **Update remote data source:**
   - Add methods for detail and evolution endpoints
   - Handle the multiple API calls for evolution

4. **Update local data source:**
   - Cache detail responses
   - Consider if evolution chains need caching

5. **Update repository implementation:**
   - Implement new methods
   - Handle caching logic

**Testing JSON parsing:**

Use fixtures from real API responses:
1. Make real API call
2. Save response as JSON file in test/fixtures/
3. Use in tests

---

### Step 3.6: Presentation — PokemonDetailBloc

**What to do:**

1. **Design state:**
   - PokemonDetailState with:
     - status (loading/loaded/error)
     - pokemonDetail (nullable)
     - evolutionChain (nullable)
     - failure

2. **Design events:**
   - PokemonDetailEvent.started(int pokemonId)
   - PokemonDetailEvent.evolutionRequested()

3. **Write BLoC tests:**
   - Started emits loading → loaded with detail
   - Error handling works
   - Evolution loading works

4. **Implement BLoC:**
   - Fetch detail on Started
   - Optionally fetch evolution (immediately or on demand)

**Loading strategy:**

Should evolution load with detail or separately?
- **Together:** Single loading state, slower initial load
- **Separately:** Detail shows fast, evolution loads after
- **Recommendation:** Separate for perceived performance

---

### Step 3.7: Presentation — Detail Page UI

**What to do:**

1. **Plan the layout:**
   - Hero image at top
   - Type badges
   - Stats section (bar chart)
   - Evolution chain section
   - Moves list (expandable/scrollable)
   - Abilities section

2. **Create section widgets:**
   - StatsChart — Bar visualization
   - EvolutionChainWidget — Visual chain
   - MovesSection — List of moves
   - AbilitiesSection — List with descriptions

3. **Write widget tests** for each section

4. **Compose in PokemonDetailPage:**
   - Use BlocBuilder
   - Handle loading/error states
   - Consider using CustomScrollView with slivers for nice scroll behavior

**Stats visualization:**

- Calculate percentage: baseStat / maxStat (255) * 100
- Color code by stat (HP = green, Attack = red, etc.)
- Animate bars on load

**Evolution chain visualization:**

- Horizontal layout for linear chains
- Handle branching (Eevee → 8 evolutions)
- Make each stage tappable (navigate to that Pokémon)

---

### Step 3.8: Hero Animation (Optional Enhancement)

**What to do:**

1. **Add Hero widget** to PokemonCard image
2. **Add matching Hero** to detail page image
3. Use same tag: `'pokemon-image-${pokemon.id}'`

**Why Hero animation?**

Provides visual continuity between list and detail. The image "flies" from card to detail page.

**Verification:**

- Smooth animation when navigating
- Animation reverses on back navigation

---

### Step 3.9: Phase 3 PR

**What to do:**

1. Create branch: `feature/phase-3-pokemon-detail`
2. Commit incrementally
3. Create PR, review, merge

---

### Phase 3 Completion Checklist

- [ ] PokemonDetail entity with all properties
- [ ] Evolution chain entities
- [ ] Detail use case with tests
- [ ] Evolution use case with tests
- [ ] Detail model with JSON parsing
- [ ] Evolution model with nested parsing
- [ ] Data sources updated
- [ ] Repository updated with caching
- [ ] PokemonDetailBloc with tests
- [ ] Detail page with all sections
- [ ] Stats chart widget
- [ ] Evolution chain widget
- [ ] Moves section
- [ ] Abilities section
- [ ] Navigation from list to detail
- [ ] Optional: Hero animation
- [ ] All tests passing
- [ ] Phase 3 merged to develop

---

## Phase 4: Battle Arena Feature

**Duration:** 6-8 days
**Goal:** Turn-based battle system with type effectiveness

---

### Step 4.1: Understand Battle Mechanics

**What to do:**

Before coding, understand the battle system:

1. **Damage formula:**
   ```
   Damage = ((2 * Level / 5 + 2) * Power * (Atk / Def) / 50 + 2) * Modifier

   Modifier = STAB * TypeEffectiveness * Random(0.85-1.00)
   ```

2. **Type effectiveness:**
   - Super effective: 2x damage
   - Not very effective: 0.5x damage
   - No effect: 0x damage
   - Double weakness: 4x (Fire vs Grass/Bug)
   - Double resistance: 0.25x

3. **STAB (Same Type Attack Bonus):**
   - 1.5x if move type matches Pokémon type

4. **Battle flow:**
   - Select move
   - Calculate damage
   - Apply damage
   - Check for KO
   - Switch turns
   - Repeat until one faints

**Why understand first?**

Battle logic is pure domain. It has no UI dependency. Understanding lets you design clean domain entities and use cases.

---

### Step 4.2: Domain — Type Effectiveness System

**What to do:**

1. **Create type effectiveness data:**
   - Create a constant map/chart of type matchups
   - Source: Pokémon type chart (well documented online)

2. **Create effectiveness calculator:**
   - Input: attacking type, defending types (can be dual-type)
   - Output: multiplier (0, 0.25, 0.5, 1, 2, 4)

3. **Write thorough tests:**
   - Fire vs Grass = 2x
   - Fire vs Water = 0.5x
   - Electric vs Ground = 0x
   - Fire vs Grass/Bug = 4x
   - Fire vs Water/Rock = 0.25x

**Implementation approaches:**

- **Nested map:** `Map<PokemonType, Map<PokemonType, double>>`
- **2D array:** Index by type enum ordinal
- **Generated code:** Define in text file, generate Dart code

**Recommendation:** Nested map for readability. Performance doesn't matter for this.

---

### Step 4.3: Domain — Battle Entities

**What to do:**

1. **BattlePokemon entity:**
   - Wraps Pokemon/PokemonDetail
   - currentHp (mutable? Or immutable with copyWith?)
   - selectedMove
   - isDefeated computed property

2. **BattleMove entity:**
   - name, power, accuracy, type
   - Simplified from full move data

3. **BattleState entity:**
   - playerPokemon: BattlePokemon
   - opponentPokemon: BattlePokemon
   - currentTurn (player/opponent)
   - battleLog: List<BattleLogEntry>
   - battleStatus (ongoing/playerWon/opponentWon)

4. **BattleLogEntry entity:**
   - Turn number
   - Attacker name
   - Move used
   - Damage dealt
   - Effectiveness message
   - Remaining HP

**Design decision:**

Mutable vs immutable battle state?
- **Immutable:** Each turn creates new state, easier to track history, better for BLoC
- **Mutable:** More "traditional", could lead to bugs
- **Recommendation:** Immutable with Freezed

---

### Step 4.4: Domain — Battle Use Cases

**What to do:**

1. **CalculateDamage use case:**
   - Pure function (no repository needed)
   - Input: attacker, defender, move
   - Output: damage amount
   - Include type effectiveness and STAB

2. **ExecuteTurn use case:**
   - Input: current battle state, selected move
   - Output: new battle state after turn
   - Calculates damage, updates HP, checks KO

3. **DetermineWinner use case:**
   - Input: battle state
   - Output: winner (or ongoing)

4. **Write extensive tests:**
   - Various type matchups
   - KO scenarios
   - Edge cases (moves with 0 power)

**Why pure use cases?**

Battle logic should be testable without any infrastructure. Pure functions are the easiest to test and reason about.

---

### Step 4.5: Data — Battle Data Source (if needed)

**What to do:**

1. **Assess data needs:**
   - Type chart: Static, can be in constants
   - Move data: Can use data from PokemonDetail
   - No API calls needed for battle itself

2. **If caching battle history:**
   - Create local data source
   - Store completed battles
   - Probably overkill for this project

**Recommendation:** Battle feature needs minimal data layer. Most logic is in domain.

---

### Step 4.6: Presentation — BattleBloc

**What to do:**

1. **Design state:**
   - BattleArenaState:
     - phase (selection/battle/finished)
     - playerPokemon (nullable)
     - opponentPokemon (nullable)
     - battleState (nullable, active during battle)
     - selectedMove (nullable)

2. **Design events:**
   - PlayerPokemonSelected(Pokemon)
   - OpponentPokemonSelected(Pokemon)
   - BattleStarted
   - MoveSelected(BattleMove)
   - TurnExecuted
   - BattleReset

3. **Write BLoC tests:**
   - Selection flow
   - Battle turn execution
   - Win/lose conditions
   - Reset functionality

4. **Implement BLoC:**
   - Inject battle use cases
   - Handle event flow

**State machine for battle phases:**

```
Selection → (both selected) → Battle → (pokemon faints) → Finished
    ↑                                                         │
    └─────────────────── (reset) ────────────────────────────┘
```

---

### Step 4.7: Presentation — Pokémon Selection UI

**What to do:**

1. **Create selection page/modal:**
   - Reuse PokemonListPage or create simplified version
   - Two selection slots (player and opponent)
   - Clear selection option

2. **Visual feedback:**
   - Show selected Pokémon preview
   - Disable "Start Battle" until both selected
   - Maybe show type matchup preview

3. **Write widget tests:**
   - Selection updates state
   - Can clear selection
   - Start button enables appropriately

---

### Step 4.8: Presentation — Battle Arena UI

**What to do:**

1. **Layout design:**
   - Player Pokémon at bottom
   - Opponent Pokémon at top
   - HP bars for both
   - Move selection buttons
   - Battle log area

2. **Create components:**
   - BattlePokemonView — Image, HP bar, name
   - HPBar — Animated health bar (green → yellow → red)
   - MoveButton — Shows move with type color
   - BattleLog — Scrollable turn history

3. **Handle battle flow:**
   - Show move options
   - Player selects move
   - Execute turn (with animation/delay)
   - Update HP bars
   - Show result
   - Repeat or end

**Animation considerations:**

- HP bar should animate smoothly
- Maybe flash on hit
- Delay between turn phases for readability
- Consider shake animation on damage

---

### Step 4.9: Presentation — Victory/Defeat Screen

**What to do:**

1. **Create result overlay:**
   - "You Win!" or "You Lose!" message
   - Winner Pokémon featured
   - Battle statistics (turns, damage dealt)
   - "Battle Again" and "Return to Pokédex" buttons

2. **Handle navigation:**
   - Battle Again resets state
   - Return navigates back to list

---

### Step 4.10: AI Opponent (Simple)

**What to do:**

1. **Implement simple opponent logic:**
   - Random move selection (simplest)
   - OR: Pick super effective move if available
   - OR: Pick highest damage move

2. **This is a use case:**
   - SelectOpponentMove use case
   - Input: opponent Pokémon, player Pokémon
   - Output: selected move

**Future enhancement:**

More sophisticated AI:
- Consider HP remaining
- Predict player moves
- Use items
- Switch Pokémon (if team battle)

---

### Step 4.11: Phase 4 PR

**What to do:**

1. Create branch: `feature/phase-4-battle-arena`
2. Commit incrementally
3. Create PR, review, merge

---

### Phase 4 Completion Checklist

- [ ] Type effectiveness system with tests
- [ ] Battle entities (BattlePokemon, BattleState, etc.)
- [ ] CalculateDamage use case
- [ ] ExecuteTurn use case
- [ ] BattleBloc with all events
- [ ] Pokémon selection UI
- [ ] Battle arena UI
- [ ] HP bars with animation
- [ ] Move selection interface
- [ ] Battle log display
- [ ] Victory/defeat screen
- [ ] Simple AI opponent
- [ ] All tests passing
- [ ] Phase 4 merged to develop

---

## Phase 5: Polish & Optimization

**Duration:** 3-5 days
**Goal:** Performance, UX improvements, documentation

---

### Step 5.1: Performance Profiling

**What to do:**

1. **Use Flutter DevTools:**
   - Profile mode build: `flutter run --profile`
   - Open DevTools performance tab

2. **Check for jank:**
   - Scroll Pokémon list rapidly
   - Navigate between screens
   - Run battle animations

3. **Identify issues:**
   - Long frame times (>16ms)
   - Excessive rebuilds
   - Memory leaks

4. **Common fixes:**
   - Add const constructors where possible
   - Use ListView.builder, not ListView
   - Cache images properly
   - Avoid building widgets in loops

---

### Step 5.2: Image Optimization

**What to do:**

1. **Add image caching:**
   - Use cached_network_image package
   - Configure memory and disk cache size

2. **Add loading placeholders:**
   - Skeleton or shimmer while loading
   - Fade in when loaded

3. **Handle errors:**
   - Show placeholder on failed load
   - Retry button or auto-retry

---

### Step 5.3: Loading States Improvement

**What to do:**

1. **Replace basic indicators:**
   - Use skeleton screens instead of spinners
   - Skeleton shows content shape before data loads

2. **Add shimmer effect:**
   - shimmer package for loading animation
   - Apply to list items, detail sections

3. **Progress indicators:**
   - Show actual progress if possible
   - "Loading 5 of 20 Pokémon" style messages

---

### Step 5.4: Error State Improvement

**What to do:**

1. **Create informative error UI:**
   - Clear message (not technical)
   - Retry button
   - Possible solutions (check internet)

2. **Different errors, different messages:**
   - Network: "No internet connection"
   - Server: "Something went wrong"
   - Not found: "Pokémon not found"

3. **Add snackbars for recoverable errors:**
   - Show briefly
   - Don't block UI

---

### Step 5.5: Empty State Handling

**What to do:**

1. **Search with no results:**
   - Friendly message
   - Maybe suggestions
   - Clear search button

2. **Filter with no results:**
   - "No [type] Pokémon found"
   - Reset filters button

3. **Add illustrations:**
   - Empty state illustrations improve UX
   - Consider sad Pikachu or similar

---

### Step 5.6: Accessibility Audit

**What to do:**

1. **Run accessibility scanner:**
   - Android: Accessibility Scanner app
   - iOS: Xcode Accessibility Inspector

2. **Check:**
   - All images have semantic labels
   - Touch targets ≥ 48dp
   - Color contrast ≥ 4.5:1
   - Text scales properly

3. **Test with screen reader:**
   - TalkBack (Android)
   - VoiceOver (iOS)
   - Ensure logical focus order

4. **Fix issues found**

---

### Step 5.7: Documentation

**What to do:**

1. **Update README.md:**
   - Clear project description
   - Screenshots/GIFs
   - Setup instructions
   - Architecture overview
   - Technologies used

2. **Generate API documentation:**
   - Run `dart doc`
   - Ensure all public APIs documented

3. **Create architecture diagram:**
   - Visual of Clean Architecture layers
   - Data flow diagram

---

### Step 5.8: Final Test Coverage Push

**What to do:**

1. **Run coverage report:**
   - `flutter test --coverage`
   - `genhtml coverage/lcov.info -o coverage/html`

2. **Identify uncovered code:**
   - Open coverage/html/index.html
   - Find red (uncovered) lines

3. **Add missing tests:**
   - Edge cases
   - Error paths
   - UI interactions

4. **Target: 85%+ coverage**

---

### Step 5.9: Create Release

**What to do:**

1. **Version bump:**
   - Update version in pubspec.yaml
   - Update CHANGELOG.md

2. **Create release branch:**
   - `git checkout -b release/1.0.0`

3. **Final testing:**
   - Full manual test pass
   - Test on real devices (not just emulator)

4. **Merge and tag:**
   - Merge to main
   - Create tag: `v1.0.0`
   - Merge back to develop

5. **CI creates release:**
   - GitHub release with APK/AAB
   - Optionally deploy to Firebase App Distribution

---

### Step 5.10: Portfolio Preparation

**What to do:**

1. **Record demo video:**
   - Screen recording of all features
   - 2-3 minutes max
   - Add voiceover or captions

2. **Take screenshots:**
   - List view
   - Detail view
   - Battle arena
   - Different states (loading, error, empty)

3. **Write project summary:**
   - What you built
   - Technologies used
   - Challenges overcome
   - What you learned

---

### Phase 5 Completion Checklist

- [ ] Performance profiled and optimized
- [ ] Images cached and optimized
- [ ] Skeleton loading screens
- [ ] Improved error states
- [ ] Empty states handled
- [ ] Accessibility audit passed
- [ ] README complete
- [ ] API docs generated
- [ ] Code coverage ≥85%
- [ ] Version 1.0.0 released
- [ ] Demo video recorded
- [ ] Screenshots captured
- [ ] Phase 5 merged to develop and main

---

## Troubleshooting Guide

### Common Issues and Solutions

---

#### Issue: Build runner fails

**Symptoms:**
- Code generation doesn't complete
- "Conflicting outputs" error

**Solutions:**
1. Run with delete flag: `dart run build_runner build --delete-conflicting-outputs`
2. Clean first: `dart run build_runner clean`
3. Check for syntax errors in annotated classes
4. Ensure all required imports are present

---

#### Issue: GetIt not finding dependency

**Symptoms:**
- "No type registered" runtime error
- Dependency not available

**Solutions:**
1. Verify `@injectable` annotation on class
2. Check `@module` annotation for third-party classes
3. Run build_runner after adding annotations
4. Verify configureDependencies() is called before accessing dependencies
5. Check injection order (dependencies before dependents)

---

#### Issue: BLoC not emitting states

**Symptoms:**
- UI not updating
- BlocBuilder not rebuilding

**Solutions:**
1. Verify event is being added: `bloc.add(event)`
2. Check that emit is being called in handler
3. Ensure state actually changed (Equatable comparison)
4. Verify BlocProvider is above BlocBuilder in widget tree
5. Check for errors in handler (add try-catch to debug)

---

#### Issue: Either fold not working as expected

**Symptoms:**
- Wrong branch executing
- Null errors

**Solutions:**
1. Verify Right vs Left usage (Right = success)
2. Check that fold handles both cases
3. Debug by logging which case is reached
4. Ensure async operations properly await

---

#### Issue: Tests failing with mock issues

**Symptoms:**
- "Missing stub" error
- Unexpected behavior in tests

**Solutions:**
1. Verify mock is registered: `when(() => mock.method()).thenReturn(value)`
2. Check parameter matchers: `any()` vs specific value
3. Ensure mock class extends Mock: `class MockX extends Mock implements X {}`
4. Reset mocks between tests if needed: `reset(mock)`

---

#### Issue: Hive type adapter errors

**Symptoms:**
- "Type not registered" error
- Serialization failures

**Solutions:**
1. Generate adapters: `@HiveType(typeId: X)`
2. Register adapters before opening boxes
3. Ensure typeId is unique across all types
4. Run build_runner after adding Hive annotations

---

#### Issue: API calls failing

**Symptoms:**
- Network errors
- Unexpected response format

**Solutions:**
1. Test endpoint in browser or Postman first
2. Check URL construction (no double slashes)
3. Verify headers (Content-Type)
4. Log request/response with Dio interceptor
5. Handle rate limiting (PokéAPI has limits)

---

#### Issue: Widget tests failing

**Symptoms:**
- "Widget not found" errors
- Pump timeouts

**Solutions:**
1. Use `await tester.pumpAndSettle()` for animations
2. Provide required dependencies (BlocProvider, etc.)
3. Mock network-dependent widgets
4. Check widget keys are correct
5. Use `find.byType` vs `find.text` appropriately

---

#### Issue: CI/CD pipeline failing

**Symptoms:**
- GitHub Actions red
- Build succeeds locally but fails in CI

**Solutions:**
1. Check workflow logs for specific error
2. Ensure all dependencies are listed in pubspec.yaml
3. Verify Flutter version matches
4. Run `flutter clean` then build locally
5. Check for platform-specific issues
6. Ensure environment variables/secrets are set

---

## Final Words

### Remember These Principles

1. **Test first, code second.** TDD feels slow initially but saves time overall.

2. **Small commits, frequent pushes.** Easier to review, easier to revert.

3. **When stuck, step back.** Re-read documentation, check assumptions.

4. **Perfect is the enemy of done.** Ship MVP, improve iteratively.

5. **Learning happens in the struggle.** Errors are teachers.

### Recommended Daily Workflow

1. **Start:** Pull latest from develop, create feature branch
2. **Plan:** Write test names/descriptions for what you'll build
3. **Build:** Red-green-refactor cycle, commit frequently
4. **End:** Push branch, create or update PR, update task list
5. **Reflect:** What did you learn? What was challenging?

### You've Got This

This project is ambitious, and that's the point. By the end, you'll have:

- Hands-on Clean Architecture experience
- Fluency with BLoC pattern
- TDD as second nature
- Professional Git workflow habits
- A portfolio-worthy project

Take it one step at a time. Every expert was once a beginner.

---

*"The journey of a thousand miles begins with a single step."* — Lao Tzu