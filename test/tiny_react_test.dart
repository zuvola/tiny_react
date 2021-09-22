import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tiny_react/tiny_react.dart';

class MyClass {}

class MyPage extends StatelessWidget {
  final count = 0.notif;

  MyPage({Key? key}) : super(key: key);

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

void main() {
  test('ValueNotifier', () {
    final num = 0.notif;
    expect(num is ValueNotifier<int>, true);
    final float = 0.0.notif;
    expect(float is ValueNotifier<double>, true);
    final boolean = false.notif;
    expect(boolean is ValueNotifier<bool>, true);
    final str = 'abc'.notif;
    expect(str is ValueNotifier<String>, true);
    final obj = MyClass().notif;
    expect(obj is ValueNotifier<MyClass>, true);
    final list = <int>[].notif;
    expect(list is CollectionNotifier<List<int>>, true);
    final map = <String, int>{}.notif;
    expect(map is CollectionNotifier<Map<String, int>>, true);
  });

  test('nullable', () {
    final num = null.notif<int>();
    expect(num is ValueNotifier<int?>, true);
    expect(num.value, isNull);
    final float = null.notif<double>();
    expect(float is ValueNotifier<double?>, true);
    expect(float.value, isNull);
    final boolean = null.notif<bool>();
    expect(boolean is ValueNotifier<bool?>, true);
    expect(boolean.value, isNull);
    final str = null.notif<String>();
    expect(str is ValueNotifier<String?>, true);
    expect(str.value, isNull);
    final obj = null.notif<MyClass>();
    expect(obj is ValueNotifier<MyClass?>, true);
    expect(obj.value, isNull);
    final list = null.iNotif<List<int>>();
    expect(list is CollectionNotifier<List<int>?>, true);
    expect(list.value, isNull);
    final map = null.iNotif<Map<String, int>>();
    expect(map is CollectionNotifier<Map<String, int>?>, true);
    expect(map.value, isNull);
  });

  test('nullable with value', () {
    final num = 0.nNotif;
    expect(num is ValueNotifier<int?>, true);
    expect(num.value, 0);
    final float = 0.0.nNotif;
    expect(float is ValueNotifier<double?>, true);
    expect(float.value, 0);
    final boolean = true.nNotif;
    expect(boolean is ValueNotifier<bool?>, true);
    expect(boolean.value, true);
    final str = 'abc'.nNotif;
    expect(str is ValueNotifier<String?>, true);
    expect(str.value, 'abc');
    final obj = MyClass().nNotif;
    expect(obj is ValueNotifier<MyClass?>, true);
    expect(obj.value is MyClass, true);
    final list = [1].nNotif;
    expect(list is CollectionNotifier<List<int>?>, true);
    expect(list.value?[0], 1);
    final map = {'abc': 1}.nNotif;
    expect(map is CollectionNotifier<Map<String, int>?>, true);
    expect(map.value?['abc'], 1);
  });

  testWidgets('widget test', (WidgetTester tester) async {
    var app = MaterialApp(
      home: MyPage(),
    );
    await tester.pumpWidget(app);
    await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
  });
}
