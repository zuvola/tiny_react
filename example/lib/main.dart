import 'package:flutter/material.dart';
import 'package:tiny_locator/tiny_locator.dart';
import 'package:tiny_react/tiny_react.dart';

class MyController {
  final num = 0.notif;
  final flag = true.notif;
  final list = <int>[].notif;

  void doSomething() {
    num.value++;
    if (num.value % 2 == 0) {
      list
        ..value.add(num.value)
        ..notifyListeners();
    }
    if (num.value % 3 == 0) {
      flag.value = !flag.value;
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
  final _app = locator.get<MyController>();

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
            _app.num.build((val) => Text('$val')),
            _app.list.build((val) => Text('$val')),
            _app.flag.build((val) => Text('$val')),
            [_app.num, _app.flag]
                .build((vals) => Text('${vals.first}/${vals.last}'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _app.doSomething(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
