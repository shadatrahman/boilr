import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../utils/file_utils.dart';
import '../utils/logger.dart';

class FeatureCommand {
  void runWithArgs(List<String> args) {
    final parser = ArgParser()..addFlag('help', abbr: 'h', help: 'Print this usage information.');

    final results = parser.parse(args);

    if (results['help'] as bool) {
      print('boilr create feature - Create a feature module with clean architecture');
      print('');
      print('Usage: boilr create feature <name>');
      print('');
      print('Arguments:');
      print('  name    The name of the feature to create');
      print('');
      print('This will create a complete feature structure with:');
      print('  - data/ (models, repositories, datasources)');
      print('  - domain/ (entities, usecases, repositories)');
      print('  - presentation/ (pages, providers, widgets)');
      return;
    }

    if (results.rest.isEmpty) {
      print('Error: Feature name is required.');
      print('Usage: boilr create feature <name>');
      return;
    }

    final featureName = results.rest[0];
    Logger.info('Creating feature: $featureName');

    try {
      _createFeatureStructure(featureName);
      _generateFeatureFiles(featureName);

      Logger.success('✅ Feature "$featureName" created successfully!');
      Logger.info('Feature structure created in lib/features/$featureName/');
    } catch (e) {
      Logger.error('Failed to create feature: $e');
    }
  }

  void _createFeatureStructure(String featureName) {
    final featurePath = path.join('lib', 'features', featureName);
    final directories = [
      'data/models',
      'data/repositories',
      'data/datasources',
      'domain/entities',
      'domain/usecases',
      'domain/repositories',
      'presentation/pages',
      'presentation/providers',
      'presentation/widgets',
    ];

    for (final dir in directories) {
      final dirPath = path.join(featurePath, dir);
      FileUtils.createDirectory(dirPath);
    }

    Logger.success('✅ Feature structure created');
  }

  void _generateFeatureFiles(String featureName) {
    final featurePath = path.join('lib', 'features', featureName);

    // Generate entity
    _generateEntity(featureName, featurePath);

    // Generate model
    _generateModel(featureName, featurePath);

    // Generate repository interface
    _generateRepositoryInterface(featureName, featurePath);

    // Generate repository implementation
    _generateRepositoryImplementation(featureName, featurePath);

    // Generate use case
    _generateUseCase(featureName, featurePath);

    // Generate provider
    _generateProvider(featureName, featurePath);

    // Generate page
    _generatePage(featureName, featurePath);

    // Update router with new feature
    _updateRouter(featureName);
  }

  void _generateEntity(String featureName, String featurePath) {
    final entityName = _toPascalCase(featureName);
    final entityContent =
        '''import 'package:equatable/equatable.dart';

class ${entityName}Entity extends Equatable {
  final int id;
  final String name;
  final String? description;

  const ${entityName}Entity({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}''';

    FileUtils.writeFile(path.join(featurePath, 'domain/entities/${featureName}_entity.dart'), entityContent);
  }

  void _generateModel(String featureName, String featurePath) {
    final modelName = _toPascalCase(featureName);
    final entityName = '${modelName}Entity';
    final modelContent =
        '''import 'package:equatable/equatable.dart';
import '../../domain/entities/${featureName}_entity.dart';

class ${modelName}Model extends Equatable {
  final int id;
  final String name;
  final String? description;

  const ${modelName}Model({
    required this.id,
    required this.name,
    this.description,
  });

  factory ${modelName}Model.fromJson(Map<String, dynamic> json) {
    return ${modelName}Model(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  $entityName toEntity() {
    return $entityName(
      id: id,
      name: name,
      description: description,
    );
  }

  @override
  List<Object?> get props => [id, name, description];
}''';

    FileUtils.writeFile(path.join(featurePath, 'data/models/${featureName}_model.dart'), modelContent);
  }

  void _generateRepositoryInterface(String featureName, String featurePath) {
    final entityName = _toPascalCase(featureName);
    final repositoryContent =
        '''import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/${featureName}_entity.dart';

abstract class ${entityName}Repository {
  Future<Either<Failure, List<${entityName}Entity>>> get${entityName}s();
  Future<Either<Failure, ${entityName}Entity>> get${entityName}ById(int id);
}''';

    FileUtils.writeFile(path.join(featurePath, 'domain/repositories/${featureName}_repository.dart'), repositoryContent);
  }

  void _generateRepositoryImplementation(String featureName, String featurePath) {
    final entityName = _toPascalCase(featureName);
    final modelName = '${entityName}Model';
    final repositoryContent =
        '''import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/${featureName}_entity.dart';
import '../../domain/repositories/${featureName}_repository.dart';
import '../models/${featureName}_model.dart';

class ${entityName}RepositoryImpl implements ${entityName}Repository {
  final Dio _dio;

  ${entityName}RepositoryImpl(this._dio);

  @override
  Future<Either<Failure, List<${entityName}Entity>>> get${entityName}s() async {
    try {
      final response = await _dio.get('/${featureName}s');
      final List<dynamic> data = response.data;
      final models = data.map((json) => ${modelName}.fromJson(json)).toList();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ${entityName}Entity>> get${entityName}ById(int id) async {
    try {
      final response = await _dio.get('/${featureName}s/\$id');
      final model = ${modelName}.fromJson(response.data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}''';

    FileUtils.writeFile(path.join(featurePath, 'data/repositories/${featureName}_repository_impl.dart'), repositoryContent);
  }

  void _generateUseCase(String featureName, String featurePath) {
    final entityName = _toPascalCase(featureName);
    final useCaseContent =
        '''import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/${featureName}_entity.dart';
import '../../domain/repositories/${featureName}_repository.dart';

class Get${entityName}sUseCase {
  final ${entityName}Repository _repository;

  Get${entityName}sUseCase(this._repository);

  Future<Either<Failure, List<${entityName}Entity>>> call() async {
    return await _repository.get${entityName}s();
  }
}''';

    FileUtils.writeFile(path.join(featurePath, 'domain/usecases/get_${featureName}s_usecase.dart'), useCaseContent);
  }

  void _generateProvider(String featureName, String featurePath) {
    final entityName = _toPascalCase(featureName);
    final providerContent =
        '''import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/${featureName}_repository_impl.dart';
import '../../domain/usecases/get_${featureName}s_usecase.dart';

final ${_toCamelCase(featureName)}RepositoryProvider = Provider((ref) {
  return ${entityName}RepositoryImpl(DioClient.instance);
});

final get${entityName}sUseCaseProvider = Provider((ref) {
  final repository = ref.watch(${_toCamelCase(featureName)}RepositoryProvider);
  return Get${entityName}sUseCase(repository);
});''';

    FileUtils.writeFile(path.join(featurePath, 'presentation/providers/${featureName}_provider.dart'), providerContent);
  }

  void _generatePage(String featureName, String featurePath) {
    final entityName = _toPascalCase(featureName);
    final pageContent =
        '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${entityName}Page extends ConsumerWidget {
  const ${entityName}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${entityName}s'),
      ),
      body: const Center(
        child: Text('${entityName} Page'),
      ),
    );
  }
}''';

    FileUtils.writeFile(path.join(featurePath, 'presentation/pages/${featureName}_page.dart'), pageContent);
  }

  void _updateRouter(String featureName) {
    final routerPath = path.join('lib', 'core', 'router', 'app_router.dart');

    // Check if router file exists
    if (!File(routerPath).existsSync()) {
      Logger.warning('Router file not found. Skipping router update.');
      return;
    }

    try {
      final routerContent = File(routerPath).readAsStringSync();
      final entityName = _toPascalCase(featureName);
      final routePath = '/${featureName}';
      final routeName = featureName;

      // Add import for the new feature page
      final importLine = "import '../../features/${featureName}/presentation/pages/${featureName}_page.dart';";
      final contentWithImport = _addImportIfNotExists(routerContent, importLine);

      // Add route constants to Router class
      final contentWithConstants = _addRouteConstants(contentWithImport, featureName, routePath, routeName);

      // Add route to the routes array
      final finalContent = _addRouteToRouter(contentWithConstants, featureName, entityName, routePath, routeName);

      File(routerPath).writeAsStringSync(finalContent);
      Logger.success('✅ Router updated with new feature route');
    } catch (e) {
      Logger.warning('Failed to update router: $e');
    }
  }

  String _addImportIfNotExists(String content, String importLine) {
    if (content.contains(importLine)) {
      return content;
    }

    // Find the last import statement and add after it
    final importRegex = RegExp(r"import '[^']+';");
    final matches = importRegex.allMatches(content).toList();

    if (matches.isNotEmpty) {
      final lastMatch = matches.last;
      final insertPosition = lastMatch.end;
      return content.substring(0, insertPosition) + '\n' + importLine + content.substring(insertPosition);
    }

    return content;
  }

  String _addRouteConstants(String content, String featureName, String routePath, String routeName) {
    final camelCaseName = _toCamelCase(featureName);
    final routeConstant =
        '''
  static const String ${camelCaseName} = '$routePath';
  static const String ${camelCaseName}Name = '$routeName';''';

    // Find the Router class and add constants before the closing brace
    final routerClassStart = content.indexOf('class Router {');
    if (routerClassStart == -1) {
      return content;
    }

    // Find the last static const in the Router class
    final lastConstMatch = RegExp(r"static const String \w+Name = '[^']+';").allMatches(content).toList();
    if (lastConstMatch.isNotEmpty) {
      final lastMatch = lastConstMatch.last;
      final insertPosition = lastMatch.end;
      return content.substring(0, insertPosition) + '\n' + routeConstant + content.substring(insertPosition);
    }

    return content;
  }

  String _addRouteToRouter(String content, String featureName, String entityName, String routePath, String routeName) {
    final camelCaseName = _toCamelCase(featureName);
    final routeToAdd =
        '''
      GoRoute(
        path: Router.${camelCaseName},
        name: Router.${camelCaseName}Name,
        builder: (context, state) => const ${entityName}Page(),
      ),''';

    // Find the routes array and add the new route
    final routesStart = content.indexOf('routes: [');
    if (routesStart == -1) {
      return content;
    }

    final routesEnd = content.indexOf('],', routesStart);
    if (routesEnd == -1) {
      return content;
    }

    // Insert the new route before the closing bracket
    final beforeRoutes = content.substring(0, routesEnd);
    final afterRoutes = content.substring(routesEnd);

    return beforeRoutes + routeToAdd + '\n    ' + afterRoutes;
  }

  String _toPascalCase(String input) {
    return input.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join('');
  }

  String _toCamelCase(String input) {
    final words = input.split('_');
    if (words.isEmpty) return input;
    return words[0].toLowerCase() + words.skip(1).map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join('');
  }
}
