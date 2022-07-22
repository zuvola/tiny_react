library tiny_react;

import 'package:flutter/widgets.dart';

/// ValueNotifier that can use [notifyListeners] for Iterable.
class CollectionNotifier<T> extends ValueNotifier<T> {
  CollectionNotifier(T value) : super(value);

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

extension ValueListenableBuilderExtension<T> on ValueNotifier<T> {
  /// Syntax sugar for [ValueListenableBuilder]
  Widget build(Widget Function(T val) builder) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (_, v, __) => builder(v),
    );
  }

  Widget call(Widget Function(T val) builder) => build(builder);
}

// ignore: prefer_void_to_null
extension NullValueNotifierExtension on Null {
  /// Syntax sugar for [ValueNotifier] in the case of nullable
  ValueNotifier<T?> notif<T>() {
    return ValueNotifier<T?>(null);
  }

  /// Syntax sugar for [CollectionNotifier] in the case of nullable
  CollectionNotifier<T?> iNotif<T>() {
    return CollectionNotifier<T?>(null);
  }
}

extension ValueNotifierExtension<T extends Object> on T {
  /// Syntax sugar for [ValueNotifier]
  ValueNotifier<T> get notif => ValueNotifier<T>(this);

  /// Syntax sugar for [ValueNotifier] in the case of nullable
  ValueNotifier<T?> get nNotif => ValueNotifier<T?>(this);
}

extension IterableNotifierExtension<T extends Iterable> on T {
  /// Syntax sugar for [CollectionNotifier]
  CollectionNotifier<T> get notif => CollectionNotifier<T>(this);

  /// Syntax sugar for [CollectionNotifier] in the case of nullable
  CollectionNotifier<T?> get nNotif => CollectionNotifier<T?>(this);
}

extension MapValueNotifierExtension<T, E> on Map<T, E> {
  /// Syntax sugar for [CollectionNotifier]
  CollectionNotifier<Map<T, E>> get notif =>
      CollectionNotifier<Map<T, E>>(this);

  /// Syntax sugar for [CollectionNotifier] in the case of nullable
  CollectionNotifier<Map<T, E>?> get nNotif =>
      CollectionNotifier<Map<T, E>?>(this);
}

extension IterableValueListenableBuilderExtension on List<ValueNotifier> {
  /// Generates multiple [ValueListenableBuilders] corresponding to List<[ValueNotifier]>
  Widget build(Widget Function(List vals) builder) => _build(builder, 0);

  Widget _build(Widget Function(List vals) builder, int index) {
    if (index >= length) return builder(map((item) => item.value).toList());
    return elementAt(index).build((val) => _build(builder, ++index));
  }

  Widget call(Widget Function(List vals) builder) => build(builder);
}
