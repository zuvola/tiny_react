# tiny_react

[![pub package](https://img.shields.io/pub/v/tiny_react.svg)](https://pub.dartlang.org/packages/tiny_react)


**[English](https://github.com/zuvola/tiny_react/blob/master/README.md), [日本語](https://github.com/zuvola/tiny_react/blob/master/README_jp.md)**


`tiny_react`は`ValueNotifier`と`ValueListenableBuilder`へのシンタックスシュガーです。  
少ないボイラープレートで`ValueNotifier`を使ったReactiveプログラミングが記述できるようになります。  
[tiny_locator](https://pub.dartlang.org/packages/tiny_locator)
と組み合わせる事で極小の状態管理ライブラリとなります。

100行未満(コメント抜き)のとても小さなライブラリなので誰でも動きの把握がしやすくなっています。  
名前の通り小ささが売りなので今後も大きな機能追加をするつもりはありませんが、小さな修正で済む機能追加などは行うかもしれません。


## Getting started

`notif`を用いて`ValueNotifier`を定義し、`build`メソッドを使って更新対象のWidgetを作成します。

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

`notif`は`ValueNotifier`へのシンタックスシュガーです。
List/Map/Setには`CollectionNotifier`という`ValueNotifier`のサブクラスが用いられます。

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

nullableの場合は下記のように定義します。

```dart
final nNum = null.notif<int>();
// final nNum = ValueNotifier<int?>(null);
final nNum2 = 0.nNotif;
// final nNum2 = ValueNotifier<int?>(0);
final list = null.iNotif<List<int>>();
// final list = CollectionNotifier(<int>[]?);
```


`build`メソッドは`ValueListenableBuilder`へのシンタックスシュガーです。
`ValueNotifier`の値を更新されると新しい値で`build`メソッドが呼ばれます。

```dart
final count = 0.notif;
count.build((val) => Text('$val'));
/// 下記と同様です
// ValueListenableBuilder<int>(
//   valueListenable: count,
//   builder: (_, v, __) => Text('$v'),
// )
/// 次のように記述する事も出来ます
// count((val) => Text('$val'));
```


複数の値を監視する場合はリストから直接`build`を呼び出す事ができます。

```dart
final count1 = 0.notif;
final count2 = 0.notif;
[count1, count2].build((vals) => Text('$vals'));
```


`ValueNotifier`の値は変更されると自動で通知されますが、リストなどのコレクションの内容が変更された場合は通知されませんので、`CollectionNotifier`にある`notifyListeners`を自分で呼び出してください。

```dart
// 自動で通知
num.value++;
// 自分で通知する必要がある
list
  ..value.add(num.value)
  ..notifyListeners();
```


## tiny_locator

[tiny_locator](https://pub.dartlang.org/packages/tiny_locator)
はサービス(オブジェクト)へのグローバルなアクセスポイントとなる小さなサービスロケータです。
tiny_reactと組み合わせることでFlutterの極小の状態管理手法になります。

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
