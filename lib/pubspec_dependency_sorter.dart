import 'dart:io';

import 'package:logger/logger.dart';
import 'package:pubspec/pubspec.dart';
import 'package:yaml_writer/yaml_writer.dart';

pubspecDependencySorter({required List<String> args}) async {
  var logger = Logger(
    filter: NewFilter(), // log in release and debug mode
    printer: PrettyPrinter(
        methodCount: 0, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  logger.w("Starting..");
  try {
    String path = '';
    if (args.isEmpty) {
      path = Directory.current.path;
    } else {
      path = args[0];
    }

    Directory myDirectory = Directory(path);
    var pubSpec = await PubSpec.load(myDirectory);

    Map<String, DependencyReference> dependencies = pubSpec.dependencies;
    Map<String, DependencyReference> devDependencies = pubSpec.devDependencies;
    Map<String, DependencyReference> dependencyOverrides =
        pubSpec.dependencyOverrides;

    var sortedDependencies = _sortDependencies(dependencies);
    logger.i("<<<--- sorted dependencies.");
    var sortedDevDependencies = _sortDependencies(devDependencies);
    logger.i("<<<--- sorted dev dependencies.");
    var sortedDependencyOverrides = _sortDependencies(dependencyOverrides);
    logger.i("<<<---- sorted dependency overrides.");

    var newPubSpec = pubSpec.copy(
      dependencies: sortedDependencies,
      dependencyOverrides: sortedDependencyOverrides,
      devDependencies: sortedDevDependencies,
    );

    var yamlWriter = YamlWriter(allowUnquotedStrings: true);
    var yamlDoc = yamlWriter.write(newPubSpec.toJson());

    var formattedYamlDoc = _formatYamlWithSpaces(yamlDoc);

    File file = File("${myDirectory.path}/pubspec.yaml");
    await file.writeAsString(formattedYamlDoc);

    logger.i("Saved the changes");
    logger.i(
        "Done---< please star and like the package. https://github.com/Genialngash/pubspec-dependency-sorter >");
  } catch (e) {
    logger.e(e);
  }
}

Map<String, DependencyReference> _sortDependencies(
    Map<String, DependencyReference> dependencies) {
  var sortedDependencies = dependencies.keys.toList();
  sortedDependencies.sort((a, b) {
    return a.toString().compareTo(b.toString());
  });

  Map<String, DependencyReference> sortDependenciesByKey = {};
  for (var key in sortedDependencies) {
    sortDependenciesByKey[key] = dependencies[key]!;
  }
  return sortDependenciesByKey;
}

String _formatYamlWithSpaces(String yamlDoc) {
  // Split the YAML document into lines
  var lines = yamlDoc.split('\n');
  // Initialize a list to hold the formatted lines
  var formattedLines = <String>[];
  // Add a blank line after each top-level key
  for (var line in lines) {
    // Check if the line contains a top-level key (starts without spaces)
    if (line.isNotEmpty && !line.startsWith(' ')) {
      formattedLines.add(''); // Add a blank line
    }

    formattedLines.add(line);
  }
  // Join the formatted lines back into a single string
  return formattedLines.join('\n');
}

class NewFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
