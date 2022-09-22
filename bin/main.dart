import 'dart:io';

import 'package:pubsec_dependecy_sorter/pubsec_dependency_sorter.dart';

void main({String? args}) {
  print("args");
  pubsecDependencySorter(args: args ?? "");
}
