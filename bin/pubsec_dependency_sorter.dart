// Copyright (c) 2022, Danche Nganga. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:collection';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:pubspec/pubspec.dart';

pubsecDependencySorter(List<String> args) async {
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
    //get the dev dependency overide
    Map<String, DependencyReference> devDependencies = pubSpec.devDependencies;
    //get the dependency overide
    Map<String, DependencyReference> dependencyOverrides =
        pubSpec.dependencyOverrides;
    //sort dependency
    var sortDependenciesByValue =
        SplayTreeMap<String, DependencyReference>.from(
      dependencies,
    );
    logger.i("<<<--- sorted dependecies.");

    //sort dev dependency
    var sortDevDependenciesByValue =
        SplayTreeMap<String, DependencyReference>.from(
      devDependencies,
    );
    logger.i("<<<--- sorted dev dependecies.");

    //sort dependency overide
    var sortDependencOveridedByValue =
        SplayTreeMap<String, DependencyReference>.from(
      dependencyOverrides,
    );
    logger.i("<<<---- sorted dependency overides.");
    // change the dependencies and dependency overides
    var newPubSpec = pubSpec.copy(
        dependencies: sortDependenciesByValue,
        dependencyOverrides: sortDependencOveridedByValue,
        devDependencies: sortDevDependenciesByValue);

    // save it
    await newPubSpec.save(myDirectory);
    logger.v("Saved the changes");

    logger.wtf("Done---< please rate and like the package.>");
  } catch (e) {
    logger.e(e);
  }
}

class NewFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
