# boilr - Flutter Project Generator CLI

**boilr** is a Dart-based command-line tool designed to accelerate Flutter application development by automatically generating complete Flutter projects with pre-configured packages, project structures, and boilerplate code.

## 🚀 Quick Start

### Installation

1. Clone this repository:

```bash
git clone <repository-url>
cd boilr
```

2. Install dependencies:

```bash
dart pub get
```

3. Make the CLI globally available (optional):

```bash
# Add to your PATH or create an alias
alias boilr="dart run /path/to/boilr/bin/boilr.dart"
```

### Basic Usage

```bash
# Run commands directly
dart run bin/boilr.dart <command>

# Or if you've set up the alias
boilr <command>
```

## 📋 Available Commands

### 1. Create Project (Main Feature)

Creates a complete Flutter project with all necessary packages and architecture:

```bash
dart run bin/boilr.dart create project <name> --org <package_name>
```

**Example:**

```bash
dart run bin/boilr.dart create project myapp --org com.example.myapp
```

**What it does:**

- Creates a new Flutter project using `flutter create`
- Adds essential packages (Riverpod, Dio, go_router, shared_preferences, dartz, etc.)
- Sets up clean architecture project structure
- Pre-configures API client with Dio
- Pre-configures routing with go_router
- Creates initial project boilerplate
- Configures state management with Riverpod

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
dart run bin/boilr.dart create feature <name>
```

**Example:**

```bash
dart run bin/boilr.dart create feature auth
```

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
dart run bin/boilr.dart create widget <name>
```

**Example:**

```bash
dart run bin/boilr.dart create widget MyButton
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
dart run bin/boilr.dart create page <name>
```

**Example:**

```bash
dart run bin/boilr.dart create page LoginPage
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
dart run bin/boilr.dart create provider <name>
```

**Example:**

```bash
dart run bin/boilr.dart create provider AuthProvider
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
dart run bin/boilr.dart --help

# Create command help
dart run bin/boilr.dart create --help

# Project command help
dart run bin/boilr.dart create project --help

# Feature command help
dart run bin/boilr.dart create feature --help

# Widget command help
dart run bin/boilr.dart create widget --help

# Page command help
dart run bin/boilr.dart create page --help

# Provider command help
dart run bin/boilr.dart create provider --help
```

## 📦 Pre-configured Packages

When creating a project, boilr automatically adds these essential packages:

### State Management

- `flutter_riverpod: ^2.4.9`
- `riverpod_annotation: ^2.3.3`

### Navigation

- `go_router: ^12.1.3`

### HTTP Client

- `dio: ^5.4.0`
- `curl_logger_dio_interceptor: ^0.0.2`

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

## 🎯 Key Benefits

1. **Complete Project Setup**: Creates fully configured Flutter projects in one command
2. **Speed**: Eliminates hours of project setup and package configuration
3. **Best Practices**: Generates code following Flutter and Dart best practices
4. **Architecture**: Pre-configured clean architecture with feature structure
5. **Integration**: Automatically includes and configures essential packages
6. **Simplicity**: One command creates a production-ready project structure

## 🚀 Getting Started with a New Project

1. **Create a new Flutter project:**

```bash
dart run bin/boilr.dart create project myapp --org com.example.myapp
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
dart run ../boilr/bin/boilr.dart create feature auth
dart run ../boilr/bin/boilr.dart create widget CustomButton
dart run ../boilr/bin/boilr.dart create page HomePage
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
