// Copyright (c) 2022, Danche Nganga. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:pubspec/pubspec.dart';
import 'package:yaml_writer/yaml_writer.dart';

main(List<String> args) async {
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
    // specify the directory
    Directory myDirectory = Directory(path);

    // load pubSpec
    var pubSpec = await PubSpec.load(myDirectory);
    //get the dependencies
    Map<String, DependencyReference> dependencies = pubSpec.dependencies;
    //get the dev dependency override
    Map<String, DependencyReference> devDependencies = pubSpec.devDependencies;
    //get the dependency override
    Map<String, DependencyReference> dependencyOverrides =
        pubSpec.dependencyOverrides;

    // sort the dependencies
    var sortedDependencies = _sortDependencies(dependencies);
    logger.i("<<<--- sorted dependencies.");

    //sort dev dependency
    var sortedDevDependencies = _sortDependencies(devDependencies);
    logger.i("<<<--- sorted dev dependencies.");

    //sort dependency override
    var sortedDependencyOverrides = _sortDependencies(dependencyOverrides);
    logger.i("<<<---- sorted dependency overrides.");
    // change the dependencies and dependency overrides

    // logger.i("Sorted dependencies: ${sortDependenciesByKey.toString()}");
    var newPubSpec = pubSpec.copy(
      dependencies: sortedDependencies,
      dependencyOverrides: sortedDependencyOverrides,
      devDependencies: sortedDevDependencies,
      unParsedYaml: pubSpec.unParsedYaml,
    );

    // save it with yaml writer
    var yamlWriter = YamlWriter(allowUnquotedStrings: true);

    // Convert the pubspec to a yaml document
    var yamlDoc = yamlWriter.write(newPubSpec.toJson());

    // Write the yaml to the pubspec.yaml file
    File file = File("${myDirectory.path}/pubspec.yaml");
    await file.writeAsString(yamlDoc);

    logger.i("Saved the changes");

    logger.i(
        "Done---< please star and like the package. https://github.com/Genialngash/pubspec-dependency-sorter >");
  } catch (e) {
    logger.e(e);
  }
}

Map<String, DependencyReference> _sortDependencies(
    Map<String, DependencyReference> dependencies) {
  // Convert the dependencies to a list and sort them
  var sortedDependencies = dependencies.keys.toList();
  sortedDependencies.sort((a, b) {
    return a.toString().compareTo(b.toString());
  });

  // sort the dependencies
  Map<String, DependencyReference> sortDependenciesByKey = {};
  for (var key in sortedDependencies) {
    sortDependenciesByKey[key] = dependencies[key]!;
  }
  return sortDependenciesByKey;
}

class NewFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
