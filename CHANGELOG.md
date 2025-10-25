## 0.0.2

### Changed

- **README Updates**: Updated installation instructions for pub.dev publication
- **Installation Method**: Changed from clone-based to `dart pub global activate boilr`
- **Command Examples**: Updated all command examples to use `boilr` directly instead of `dart run bin/boilr.dart`

## 0.0.1

### Added

- **Centralized Router Class**: Type-safe navigation with Router constants
- **Named Routes**: Support for `context.goNamed()` navigation with automatic route registration
- **Professional Development Environment**: Comprehensive linting and formatting configuration
- **Analysis Options**: Strict type checking with `analysis_options.yaml`
- **VS Code Integration**: Automatic formatting and code actions with `.vscode/settings.json`
- **Automatic Route Updates**: Features automatically register routes in Router class
- **CamelCase Naming**: Provider variables follow Dart naming conventions
- **Clean Code Generation**: All generated code is lint-free and follows best practices

### Enhanced

- **Feature Command**: Now automatically updates router with new routes
- **Project Generation**: Includes professional development environment setup
- **Code Quality**: Strict linting rules and const optimization
- **Type Safety**: Enhanced type checking and inference
- **Developer Experience**: Zero-configuration VS Code setup

### Fixed

- **DioClient Type Mismatch**: Fixed Dio vs DioClient type issues in repository implementations
- **Static Getter Access**: Corrected static getter access patterns
- **Import Issues**: Added missing Dio imports in repository implementations
- **Naming Conventions**: Fixed provider variable naming to follow camelCase
- **Unused Imports**: Removed unused imports from generated page files

### Technical Improvements

- **Router System**: Centralized route management with type safety
- **Linting Configuration**: Professional-grade code quality rules
- **Formatter Settings**: Trailing commas preservation for cleaner diffs
- **VS Code Settings**: Automatic formatting and import organization
- **Package Updates**: Updated Dio to 5.9.0 and curl_logger_dio_interceptor to 1.0.0
