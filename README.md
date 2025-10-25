# boilr - Flutter Project Generator CLI

**boilr** is a Dart-based command-line tool designed to accelerate Flutter application development by automatically generating complete Flutter projects with pre-configured packages, project structures, and boilerplate code.

## 🚀 Quick Start

### Installation

Install boilr globally using Dart's pub tool:

```bash
dart pub global activate boilr
```

**Note:** Make sure your `$PATH` includes the pub global bin directory. The directory location varies by platform:

- **macOS/Linux:** `~/.pub-cache/bin`
- **Windows:** `%LOCALAPPDATA%\Pub\Cache\bin`

To add it permanently:

**macOS/Linux:**
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

**Windows (PowerShell):**
```powershell
[Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + ";$env:LOCALAPPDATA\Pub\Cache\bin", "User")
```

### Basic Usage

```bash
# Run commands directly
boilr <command>
```

## 📋 Available Commands

### 1. Create Project (Main Feature)

Creates a complete Flutter project with all necessary packages and architecture:

```bash
boilr create project <name> --org <package_name>
```

**Example:**

```bash
boilr create project myapp --org com.example.myapp
```

**What it does:**

- Creates a new Flutter project using `flutter create`
- Adds essential packages (Riverpod, Dio, go_router, shared_preferences, dartz, etc.)
- Sets up clean architecture project structure
- Pre-configures API client with Dio
- Pre-configures routing with go_router and centralized Router class
- Creates initial project boilerplate
- Configures state management with Riverpod
- **NEW**: Adds comprehensive linting configuration (`analysis_options.yaml`)
- **NEW**: Includes VS Code settings for automatic formatting
- **NEW**: Implements named routes for type-safe navigation
- **NEW**: Sets up professional development environment

**Generated Structure:**

```
lib/
├── core/
│   ├── constants/
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── interceptors/
│   ├── storage/
│   │   └── token_manager.dart
│   ├── router/
│   │   └── app_router.dart
│   └── error/
│       └── failures.dart
├── features/
├── shared/
│   ├── widgets/
│   ├── providers/
│   └── functions/
└── main.dart
```

### 2. Create Feature

Creates a complete feature module following clean architecture principles:

```bash
boilr create feature <name>
```

**Example:**

```bash
boilr create feature auth
```

**What it does:**

- Creates complete feature structure with data/domain/presentation layers
- Generates entity, model, repository, use case, and provider files
- **NEW**: Automatically adds route to Router class
- **NEW**: Updates app_router.dart with new feature route
- **NEW**: Implements type-safe navigation with named routes
- **NEW**: Follows camelCase naming conventions
- **NEW**: Generates clean, lint-free code

**Generated Structure:**

```
lib/features/<name>/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── usecases/
│   └── repositories/
└── presentation/
    ├── pages/
    ├── providers/
    └── widgets/
```

### 3. Create Widget

Generates a ConsumerWidget with Riverpod integration:

```bash
boilr create widget <name>
```

**Example:**

```bash
boilr create widget MyButton
```

**Generated Code:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyButton extends ConsumerWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
```

### 4. Create Page

Creates a Flutter screen with Riverpod integration:

```bash
boilr create page <name>
```

**Example:**

```bash
boilr create page LoginPage
```

**Generated Code:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginpageProvider = StateProvider<bool>((ref) => false);

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loginpageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('LoginPage'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text('LoginPage'),
      ),
    );
  }
}
```

### 5. Create Provider

Generates a Riverpod provider and state class:

```bash
boilr create provider <name>
```

**Example:**

```bash
boilr create provider AuthProvider
```

**Generated Code:**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authproviderProvider = StateProvider<bool>((ref) => false);

class AuthProvider {
  static void updateAuthProviderState(WidgetRef ref, bool value) {
    ref.read(authproviderProvider.notifier).state = value;
  }
}
```

## 🛠️ Help Commands

Get help for any command:

```bash
# General help
boilr --help

# Create command help
boilr create --help

# Project command help
boilr create project --help

# Feature command help
boilr create feature --help

# Widget command help
boilr create widget --help

# Page command help
boilr create page --help

# Provider command help
boilr create provider --help
```

## 📦 Pre-configured Packages

When creating a project, boilr automatically adds these essential packages:

### State Management

- `flutter_riverpod: ^2.4.9`
- `riverpod_annotation: ^2.3.3`

### Navigation

- `go_router: ^12.1.3`

### HTTP Client

- `dio: ^5.9.0`
- `curl_logger_dio_interceptor: ^1.0.0`

### Local Storage

- `shared_preferences: ^2.2.2`

### Functional Programming

- `dartz: ^0.10.1`

### Utilities

- `equatable: ^2.0.5`
- `logger: ^2.0.2+1`

## 🏗️ Architecture

boilr generates projects following clean architecture principles:

- **Feature Modules**: Self-contained feature modules with data/domain/presentation layers
- **Service Layer**: API services for each feature
- **Provider Pattern**: Riverpod providers for state management
- **Model Classes**: Data models with JSON serialization
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: Loose coupling between layers

## 🛠️ Development Environment

boilr sets up a professional development environment with:

### Code Quality & Linting

- **Strict Type Checking**: Enforces explicit type inference and raw types
- **Const Optimization**: Promotes const usage for better performance
- **Flutter Lints**: Includes `package:flutter_lints/flutter.yaml`
- **Custom Rules**: Pre-configured linting rules for production code

### VS Code Integration

- **Automatic Formatting**: Formats code on save
- **Code Actions**: Auto-fixes linting issues and organizes imports
- **Dart-Specific Settings**: Optimized for Flutter development

### Navigation System

- **Centralized Router**: Type-safe route constants in Router class
- **Named Routes**: Support for `context.goNamed()` navigation
- **Automatic Updates**: New features automatically register routes
- **Type Safety**: Autocomplete and refactoring support

### Generated Configuration Files

**analysis_options.yaml:**

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  language:
    strict-inference: true
    strict-raw-types: true
  errors:
    prefer_const_constructors: warning
    prefer_const_literals_to_create_immutables: warning
    prefer_const_declarations: warning

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    prefer_const_declarations: true

formatter:
  trailing_commas: preserve
```

**.vscode/settings.json:**

```json
{
  "editor.formatOnSave": true,
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll": "always",
      "source.organizeImports": "always"
    }
  }
}
```

## 🧭 Navigation System

boilr generates a centralized Router class for type-safe navigation:

### Router Class

```dart
class Router {
  // Route paths
  static const String login = '/login';
  static const String home = '/home';
  static const String userProfile = '/user_profile';

  // Route names for context.goNamed()
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String userProfileName = 'user_profile';
}
```

### Navigation Examples

```dart
// Navigate using path
context.go(Router.userProfile);
context.push(Router.home);

// Navigate using named routes
context.goNamed(Router.userProfileName);
context.pushNamed(Router.homeName);
```

### Automatic Route Registration

When you create a new feature, it's automatically added to the Router:

```bash
boilr create feature product_catalog
# Automatically adds:
# - Router.productCatalog = '/product_catalog'
# - Router.productCatalogName = 'product_catalog'
# - GoRoute with path and name parameters
```

## 🎯 Key Benefits

1. **Complete Project Setup**: Creates fully configured Flutter projects in one command
2. **Speed**: Eliminates hours of project setup and package configuration
3. **Best Practices**: Generates code following Flutter and Dart best practices
4. **Architecture**: Pre-configured clean architecture with feature structure
5. **Integration**: Automatically includes and configures essential packages
6. **Simplicity**: One command creates a production-ready project structure
7. **NEW**: Professional development environment with linting and formatting
8. **NEW**: Type-safe navigation with centralized Router class
9. **NEW**: Zero-configuration VS Code setup
10. **NEW**: Automatic route registration for new features

## 🚀 Getting Started with a New Project

1. **Create a new Flutter project:**

```bash
boilr create project myapp --org com.example.myapp
```

2. **Navigate to your project:**

```bash
cd myapp
```

3. **Install dependencies:**

```bash
flutter pub get
```

4. **Run your app:**

```bash
flutter run
```

5. **Add features as needed:**

```bash
# From within your project directory
boilr create feature auth
boilr create widget CustomButton
boilr create page HomePage
```

## 🔧 Development

### Project Structure

```
boilr/
├── bin/
│   └── boilr.dart              # Main CLI entry point
├── lib/
│   └── src/
│       ├── commands/           # Command implementations
│       │   ├── create_command.dart
│       │   ├── project_command.dart
│       │   ├── feature_command.dart
│       │   ├── widget_command.dart
│       │   ├── page_command.dart
│       │   └── provider_command.dart
│       └── utils/              # Utility functions
│           ├── file_utils.dart
│           └── logger.dart
└── pubspec.yaml
```

### Adding New Commands

1. Create a new command class in `lib/src/commands/`
2. Implement the `runWithArgs(List<String> args)` method
3. Add the command to the create command switch statement
4. Update this README with usage instructions

## 📝 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have questions, please open an issue on the repository.
