import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../utils/file_utils.dart';
import '../utils/logger.dart';

class ProjectCommand {
  void runWithArgs(List<String> args) {
    final parser = ArgParser()
      ..addOption('org', abbr: 'o', help: 'Organization/package name (e.g., com.example.myapp)')
      ..addFlag('help', abbr: 'h', help: 'Print this usage information.');

    try {
      final results = parser.parse(args);

      if (results['help'] as bool) {
        print('boilr create project - Create a complete Flutter project with pre-configured packages');
        print('');
        print('Usage: boilr create project <name> [options]');
        print('');
        print('Arguments:');
        print('  name    The name of the Flutter project to create');
        print('');
        print('Options:');
        print(parser.usage);
        return;
      }

      if (results.rest.isEmpty) {
        print('Error: Project name is required.');
        print('Usage: boilr create project <name> [options]');
        return;
      }

      final projectName = results.rest[0];
      final org = results['org'] as String?;

      if (org == null) {
        print('Error: Organization/package name is required.');
        print('Use --org or -o to specify the organization (e.g., com.example.myapp)');
        return;
      }

      Logger.info('Creating Flutter project: $projectName');
      Logger.info('Organization: $org');

      try {
        _createFlutterProject(projectName, org);
        _addDependencies(projectName);
        _createProjectStructure(projectName);
        _generateBoilerplateCode(projectName);

        Logger.success('✅ Flutter project "$projectName" created successfully!');
        Logger.info('Next steps:');
        Logger.info('  cd $projectName');
        Logger.info('  flutter pub get');
        Logger.info('  flutter run');
      } catch (e) {
        Logger.error('Failed to create project: $e');
        exit(1);
      }
    } catch (e) {
      Logger.error('Error parsing arguments: $e');
      print('Run "boilr create project --help" for usage information.');
    }
  }

  void _createFlutterProject(String projectName, String org) {
    Logger.info('Running flutter create...');

    final result = Process.runSync('flutter', ['create', projectName, '--org', org], runInShell: true);

    if (result.exitCode != 0) {
      throw Exception('Failed to create Flutter project: ${result.stderr}');
    }

    Logger.success('✅ Flutter project created');
  }

  void _addDependencies(String projectName) {
    Logger.info('Adding dependencies to pubspec.yaml...');

    final pubspecPath = path.join(projectName, 'pubspec.yaml');
    final pubspecContent = File(pubspecPath).readAsStringSync();

    // Add dependencies after the existing dependencies section
    final dependenciesToAdd = '''
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # Navigation
  go_router: ^12.1.3
  
  # HTTP Client
  dio: ^5.9.0
  curl_logger_dio_interceptor: ^1.0.0
  
  # Local Storage
  shared_preferences: ^2.2.2
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Utilities
  equatable: ^2.0.5
  logger: ^2.0.2+1''';

    final updatedContent = pubspecContent.replaceFirst(RegExp(r'dependencies:\s*\n'), 'dependencies:$dependenciesToAdd\n');

    File(pubspecPath).writeAsStringSync(updatedContent);
    Logger.success('✅ Dependencies added');
  }

  void _createProjectStructure(String projectName) {
    Logger.info('Creating project structure...');

    final libPath = path.join(projectName, 'lib');
    final directories = [
      'core/constants',
      'core/network',
      'core/network/interceptors',
      'core/storage',
      'core/router',
      'core/error',
      'features/auth/presentation/pages',
      'features/home/presentation/pages',
      'shared/widgets',
      'shared/providers',
      'shared/functions',
      'shared/enums',
      'shared/validators',
    ];

    for (final dir in directories) {
      final dirPath = path.join(libPath, dir);
      Directory(dirPath).createSync(recursive: true);
    }

    Logger.success('✅ Project structure created');
  }

  void _generateBoilerplateCode(String projectName) {
    Logger.info('Generating boilerplate code...');

    _generateDioClient(projectName);
    _generateInterceptors(projectName);
    _generateTokenManager(projectName);
    _generateAppRouter(projectName);
    _generateErrorHandling(projectName);
    _generateMainDart(projectName);
    _generateExamplePages(projectName);

    Logger.success('✅ Boilerplate code generated');
  }

  void _generateDioClient(String projectName) {
    final dioClientContent = '''import 'package:dio/dio.dart';
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
}''';

    FileUtils.writeFile(path.join(projectName, 'lib/core/network/dio_client.dart'), dioClientContent);
  }

  void _generateTokenManager(String projectName) {
    final tokenManagerContent = '''import 'package:shared_preferences/shared_preferences.dart';

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
}''';

    FileUtils.writeFile(path.join(projectName, 'lib/core/storage/token_manager.dart'), tokenManagerContent);
  }

  void _generateAppRouter(String projectName) {
    final appRouterContent = '''import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

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
});''';

    FileUtils.writeFile(path.join(projectName, 'lib/core/router/app_router.dart'), appRouterContent);
  }

  void _generateErrorHandling(String projectName) {
    final failuresContent = '''abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error occurred']) : super(message);
}''';

    FileUtils.writeFile(path.join(projectName, 'lib/core/error/failures.dart'), failuresContent);
  }

  void _generateMainDart(String projectName) {
    final mainContent = '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,
    );
  }
}''';

    FileUtils.writeFile(path.join(projectName, 'lib/main.dart'), mainContent);
  }

  void _generateInterceptors(String projectName) {
    // Generate Auth Interceptor
    final authInterceptorContent = '''import 'package:dio/dio.dart';
import '../../storage/token_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenManager.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer \$token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await TokenManager.clearTokens();
      // Navigate to login page
    }
    handler.next(err);
  }
}''';

    FileUtils.writeFile(path.join(projectName, 'lib/core/network/interceptors/auth_interceptor.dart'), authInterceptorContent);

    // Generate Logging Interceptor
    final loggingInterceptorContent = '''import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[\${options.method}] => PATH: \${options.path}');
    print('Headers: \${options.headers}');
    print('Data: \${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[\${response.statusCode}] => PATH: \${response.requestOptions.path}');
    print('Data: \${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[\${err.response?.statusCode}] => PATH: \${err.requestOptions.path}');
    print('Message: \${err.message}');
    handler.next(err);
  }
}''';

    FileUtils.writeFile(path.join(projectName, 'lib/core/network/interceptors/logging_interceptor.dart'), loggingInterceptorContent);
  }

  void _generateExamplePages(String projectName) {
    // Generate Login Page
    final loginPageContent = '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Center(
        child: Text('Login Page'),
      ),
    );
  }
}''';

    FileUtils.writeFile(path.join(projectName, 'lib/features/auth/presentation/pages/login_page.dart'), loginPageContent);

    // Generate Home Page
    final homePageContent = '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}''';

    FileUtils.writeFile(path.join(projectName, 'lib/features/home/presentation/pages/home_page.dart'), homePageContent);
  }
}
