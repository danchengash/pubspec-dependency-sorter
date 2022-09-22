import 'dart:io';

import 'package:pubsec_dependecy_sorter/pubsec_dependency_sorter.dart';

void main() {
  String? path = stdin.readLineSync();
  print(path);
  pubsecDependencySorter(args: path??"");
}
