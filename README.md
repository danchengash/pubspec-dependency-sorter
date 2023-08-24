<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
Package helps to sort the flutter/dart packages and plugins alphabetically, This makes it easier when managing too many packages and when working with teams

## Features

* sort dependencies
* prevent dependecy conflicts
* clean up the pubspec.yaml file

## Getting started
Install flutter or dart sdk then depend on the package.
```dart
dev_dependencies:
  pubspec_dependency_sorter: ^1.0.4
```

## Usage

To use the package run in your flutter/dart app root directory
```dart
   flutter pub run pubspec_dependency_sorter
```
if your pubspec.yam is located somewhere else use the following command by passing the **path of the directory** where the pubspec.yaml file is located.
```dart
  flutter pub run pubspec_dependency_sorter PATH-TO-YOUR-DIRECTORY
```
## sample output
![dependency_sorter sample output](https://github.com/Genialngash/pubspec-dependency-sorter/blob/main/images/pubspec%20_dependency_sorter.png)


## Additional information
Feel free to add features,improvemets and fix bugs then create a PR.
