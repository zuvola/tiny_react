# tiny_react

[![pub package](https://img.shields.io/pub/v/tiny_react.svg)](https://pub.dartlang.org/packages/tiny_react)


**[English](https://github.com/zuvola/tiny_react/blob/master/README.md), [日本語](https://github.com/zuvola/tiny_react/blob/master/README_jp.md)**


`tiny_react` is a syntax sugar for `ValueNotifier` and `ValueListenableBuilder`.  
You will be able to write Reactive programming using `ValueNotifier` with fewer boilerplates.  
It can be combined with [tiny_locator](https://pub.dartlang.org/packages/tiny_locator) to make a tiny state management library.

It is a very small library with less than 100 lines (without comments), so it is easy for anyone to understand how it works.  
As the name suggests, it is a small library, so I don't plan to add major features in the future, but I may add features that require only small modifications.


## Getting started

Define a `ValueNotifier` using `notif` and create a Widget that will be updated using the `build` method.

```dart
class MyPage extends StatelessWidget {
  final count = 0.notif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: count.build((val) => Text('$val')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => count.value++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```


## Usage

`notif` is a syntax sugar for `ValueNotifier`.  
A subclass of `ValueNotifier` called `CollectionNotifier` is used for List/Map/Set.

```dart
final num = 0.notif;
// final num = ValueNotifier(0);
final float = 0.0.notif;
// final float = ValueNotifier(0.0);
final boolean = false.notif;
// final boolean = ValueNotifier(false);
final str = 'abc'.notif;
// final str = ValueNotifier('abc');
final obj = MyClass().notif;
// final obj = ValueNotifier(MyClass());
final list = <int>[].notif;
// final list = CollectionNotifier(<int>[]);
final map = <String, int>{}.notif;
// final map = CollectionNotifier(<String, int>{});
```

In the case of nullable, it is defined as follows

```dart
final nNum = null.notif<int>();
// final nNum = ValueNotifier<int?>(null);
final nNum2 = 0.nNotif;
// final nNum2 = ValueNotifier<int?>(0);
final list = null.iNotif<List<int>>();
// final list = CollectionNotifier(<int>[]?);
```


The `build` method is a syntax sugar to `ValueListenableBuilder`.  
When the value of `ValueNotifier` is updated, the `build` method is called with the new value.

```dart
final count = 0.notif;
count.build((val) => Text('$val'));
/// same as
// ValueListenableBuilder<int>(
//   valueListenable: count,
//   builder: (_, v, __) => Text('$v'),
// )
/// you can use as follows
// count((val) => Text('$val'));
```


The value of `ValueNotifier` is automatically notified when it is changed, but not when the content of collections such as `List` is changed, so you should call `notifyListeners` in `CollectionNotifier` by yourself.

```dart
// automatic notification
num.value++;
// collections objects require notification by myself
list
  ..value.add(num.value)
  ..notifyListeners();
```


## tiny_locator

[tiny_locator](https://pub.dartlang.org/packages/tiny_locator)
 is a tiny service locator that serves as a global access point to services.
When combined with `tiny_react`, it becomes Flutter's tiny state management method.

```dart
import 'package:flutter/material.dart';
import 'package:tiny_locator/tiny_locator.dart';
import 'package:tiny_react/tiny_react.dart';

class MyController {
  final num = 0.notif;
  final list = <int>[].notif;

  void doSomething() {
    num.value++;
    if (num.value % 2 == 0) {
      list
        ..value.add(num.value)
        ..notifyListeners();
    }
  }
}

void main() {
  locator.add(() => MyController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  final controller = locator.get<MyController>();

  MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyPage')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            controller.num.build((val) => Text('$val')),
            controller.list.build((val) => Text('$val')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.doSomething(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
