# boilr - Understanding Document

## Project Overview

**boilr** is a Dart-based command-line tool designed to accelerate Flutter application development by automatically generating complete Flutter projects with pre-configured packages, project structures, and boilerplate code.

### Core Philosophy

_"Stop writing boilerplate — focus on building features."_

## Problem Statement

Flutter developers often spend significant time on project setup:

- Creating new Flutter projects with proper structure
- Adding and configuring essential packages (Riverpod, Dio, etc.)
- Setting up project architecture (clean architecture, feature structure)
- Configuring API clients and state management
- Writing initial boilerplate code and project structure

## Solution Approach

boilr provides a CLI interface that automatically creates complete Flutter projects with all necessary packages, architecture, and boilerplate code pre-configured, allowing developers to start coding features immediately.

## Core Commands & Functionality

### 1. Project Creation (Primary Command)

```bash
boilr create project <name> --org <package_name>
```

**Purpose**: Creates a complete Flutter project with all necessary packages and architecture
**Features**:

- Uses `flutter create` CLI under the hood
- Automatically adds essential packages (Riverpod, Dio, go_router, shared_preferences, dartz, etc.)
- Sets up clean architecture project structure
- Pre-configures API client with Dio
- Pre-configures routing with go_router
- Creates initial project boilerplate
- Configures state management with Riverpod

**Example**:

```bash
boilr create project myapp --org com.example.myapp
```

**What it does**:

1. Runs `flutter create myapp --org com.example.myapp`
2. Adds packages to pubspec.yaml (riverpod, dio, go_router, shared_preferences, dartz, etc.)
3. Creates project structure with features/ directory
4. Generates Dio client configuration with interceptors
5. Sets up go_router configuration with initial routes and navigation logic
6. Configures SharedPreferences for token management
7. Sets up initial Riverpod providers with dartz error handling
8. Creates example feature structure with complete clean architecture

### 2. Feature Generation (Within Existing Project)

```bash
boilr create feature <name>
```

**Purpose**: Creates complete feature architecture following clean architecture principles
**Output Structure**:

```
lib/features/<name>/
├── data/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── usecases/
└── presentation/
    ├── pages/
    ├── providers/
    └── widgets/
```

### 3. Widget Creation

```bash
boilr create widget <name>
```

**Purpose**: Generates ConsumerWidget with Riverpod integration
**Features**:

- Automatic import statements (Flutter + Riverpod)
- ConsumerWidget class structure
- WidgetRef parameter handling
- Riverpod state management ready

### 4. Page Creation

```bash
boilr create page <name>
```

**Purpose**: Creates Flutter screens with Riverpod integration
**Features**:

- Scaffold structure
- Riverpod provider integration
- ConsumerWidget implementation
- State management setup

### 5. Provider Generation

```bash
boilr create provider <name>
```

**Purpose**: Generates Riverpod providers and state classes
**Features**:

- StateProvider creation
- Proper typing
- State management patterns

## Technical Architecture

### Technology Stack

- **Language**: Dart
- **Dependencies**: args, yaml, path, io
- **Entry Point**: bin/boilr.dart
- **Command Pattern**: Modular command structure in /lib/src/commands/
- **Code Generation**: Inline template generation

### Generated Flutter Project Structure

The CLI will generate Flutter projects with the following structure:

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_service.dart
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       └── logging_interceptor.dart
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── token_manager.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── routes.dart
│   └── error/
│       ├── failures.dart
│       └── exceptions.dart
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── models/
│       │   ├── repositories/
│       │   └── datasources/
│       ├── domain/
│       │   ├── entities/
│       │   ├── usecases/
│       │   └── repositories/
│       └── presentation/
│           ├── pages/
│           ├── providers/
│           └── widgets/
├── shared/
│   ├── widgets/
│   └── utils/
└── main.dart
```

### CLI Tool Structure

```
boilr/
├── bin/
│   └── boilr.dart
├── lib/
│   └── src/
│       ├── commands/
│       │   ├── create_command.dart
│       │   ├── project_command.dart
│       │   ├── feature_command.dart
│       │   ├── widget_command.dart
│       │   ├── page_command.dart
│       │   └── provider_command.dart
│       └── utils/
│           ├── file_utils.dart
│           ├── string_utils.dart
│           └── logger.dart
└── pubspec.yaml
```

## Generated Code Examples

The CLI will generate code inline without external template files. Examples of what will be generated:

### Widget Generation

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
```

### Page with Riverpod

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = StateProvider<bool>((ref) => false);

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loginProvider);
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text('Login Page'),
      ),
    );
  }
}
```

### Dio Client Generation

```dart
import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.addAll([
    LoggingInterceptor(),
    AuthInterceptor(),
  ]);

  static Dio get instance => _dio;
}
```

### Token Management with SharedPreferences

```dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
```

### Go Router Configuration

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
});
```

### Error Handling with Dartz

```dart
import 'package:dartz/dartz.dart';
import '../core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetUserUseCase implements UseCase<User, String> {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(String userId) async {
    try {
      final user = await repository.getUser(userId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

## Key Benefits

1. **Complete Project Setup**: Creates fully configured Flutter projects in one command
2. **Speed**: Eliminates hours of project setup and package configuration
3. **Best Practices**: Generates code following Flutter and Dart best practices
4. **Architecture**: Pre-configured clean architecture with feature structure
5. **Integration**: Automatically includes and configures essential packages (Riverpod, Dio, go_router, SharedPreferences, dartz)
6. **Simplicity**: One command creates a production-ready project structure

## Target Users

- **Personal CLI Tool**: Designed for individual Flutter developers
- Developers who want to focus on business logic rather than setup
- Projects using clean architecture patterns
- Developers using Riverpod for state management
- Personal productivity tool for rapid prototyping

## Development Phases

### Phase 1 Deliverables (Completed)

- ✅ Basic CLI runner
- ✅ create project command (main command)
- ✅ create feature command
- ✅ create widget command
- ✅ create page command
- ✅ create provider command (Riverpod)

## Future Considerations

The document mentions a decision point regarding state management:

- **Default**: Riverpod
- **Alternatives**: Bloc, Provider, or plain StatefulWidget

This choice will determine how template logic is wired in the initial version.

## Success Metrics

- Reduced time to create new features
- Consistent code structure across projects
- Developer adoption and satisfaction
- Reduced onboarding time for new team members
- Maintainability improvements in generated code

## Source of Truth: Nationalist Project Patterns

The CLI will generate Flutter projects based on proven patterns from the nationalist project, including:

### Project Structure

```
lib/
├── api_client/           # API client with Dio
│   ├── core/
│   ├── models/
│   └── repositories/
├── core/                 # Core utilities and services
│   ├── models/
│   ├── routes/
│   ├── services/
│   └── utils/
├── features/             # Feature modules
│   ├── auth/
│   ├── account/
│   ├── home/
│   └── [feature]/
├── shared/               # Shared components
│   ├── widgets/
│   ├── providers/
│   └── functions/
└── main.dart
```

### Navigation & Routing

- **Go Router**: Declarative routing with type-safe navigation
- **Route Constants**: Centralized route definitions
- **Initial Navigation Logic**: Token-based initial route determination
- **Global Context**: Access to navigation context anywhere
- **Route Parameters**: Type-safe parameter passing

### State Management

- **Riverpod with Code Generation**: Using `@riverpod` annotation
- **AsyncNotifier**: For async state handling
- **Provider Dependencies**: Automatic dependency injection
- **Keep Alive Providers**: Persistent state across rebuilds
- **Generated Providers**: Auto-generated provider files

### API & Network

- **Dio Client**: HTTP client with comprehensive error handling
- **Token Management**: Automatic token injection and refresh
- **SharedPreferences Integration**: Token persistence
- **Error Interceptors**: 401 handling and automatic logout
- **Curl Logger**: Request/response logging for debugging
- **File Upload/Download**: Multipart file handling

### Storage & Persistence

- **SharedPreferences Service**: Centralized local storage
- **Token Management**: Secure token storage and retrieval
- **User Data Persistence**: User ID, username, language preferences
- **Guest Mode**: Support for guest user sessions

### Error Handling

- **Dartz Either**: Functional error handling with `ApiResponse<T>`
- **Categorized Error Types**: Network, Server, Validation, Auth errors
- **Status Code Mapping**: HTTP status to specific error types
- **Validation Details**: Detailed validation error information
- **Error Extensions**: Helper methods for error handling

### Architecture Patterns

- **Feature Modules**: Self-contained feature modules (`features/`)
- **Service Layer**: API services for each feature
- **Provider Pattern**: Riverpod providers for state management
- **Model Classes**: Data models with JSON serialization
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: Loose coupling between layers

### Key Dependencies

- **flutter_riverpod**: State management
- **riverpod_annotation**: Code generation
- **go_router**: Navigation
- **dio**: HTTP client
- **shared_preferences**: Local storage
- **dartz**: Functional programming
- **equatable**: Value equality
- **logger**: Logging
- **curl_logger_dio_interceptor**: Request logging
