import 'dart:io';

import 'package:pubsec_dependecy_sorter/pubsec_dependency_sorter.dart';

void main(List<String> args) {
  final String path;
  if (args.isEmpty) {
    path = Directory.current.path;
  } else {
    path = args[0];
  }
  pubsecDependencySorter(path);
}
