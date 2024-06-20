// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs_enum_map.dart';

// **************************************************************************
// UnmodifiableEnumMapGenerator
// **************************************************************************

class UnmodifiableTabEnumMap<V> implements Map<TabEnum, V> {
  final V one;
  final V two;
  final V three;

  const UnmodifiableTabEnumMap({
    required this.one,
    required this.two,
    required this.three,
  });

  @override
  Map<RK, RV> cast<RK, RV>() {
    return Map.castFrom<TabEnum, V, RK, RV>(this);
  }

  @override
  bool containsValue(Object? value) {
    if (this.one == value) return true;
    if (this.two == value) return true;
    if (this.three == value) return true;
    return false;
  }

  @override
  bool containsKey(Object? key) {
    return key.runtimeType == TabEnum;
  }

  @override
  V? operator [](Object? key) {
    switch (key) {
      case TabEnum.one:
        return this.one;
      case TabEnum.two:
        return this.two;
      case TabEnum.three:
        return this.three;
    }

    return null;
  }

  @override
  void operator []=(TabEnum key, V value) {
    throw Exception("Cannot modify this map.");
  }

  @override
  Iterable<MapEntry<TabEnum, V>> get entries {
    return [
      MapEntry<TabEnum, V>(TabEnum.one, this.one),
      MapEntry<TabEnum, V>(TabEnum.two, this.two),
      MapEntry<TabEnum, V>(TabEnum.three, this.three),
    ];
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> transform(TabEnum key, V value)) {
    final one = transform(TabEnum.one, this.one);
    final two = transform(TabEnum.two, this.two);
    final three = transform(TabEnum.three, this.three);
    return {
      one.key: one.value,
      two.key: two.value,
      three.key: three.value,
    };
  }

  @override
  void addEntries(Iterable<MapEntry<TabEnum, V>> newEntries) {
    throw Exception("Cannot modify this map.");
  }

  @override
  V update(TabEnum key, V update(V value), {V Function()? ifAbsent}) {
    throw Exception("Cannot modify this map.");
  }

  @override
  void updateAll(V update(TabEnum key, V value)) {
    throw Exception("Cannot modify this map.");
  }

  @override
  void removeWhere(bool test(TabEnum key, V value)) {
    throw Exception("Objects in this map cannot be removed.");
  }

  @override
  V putIfAbsent(TabEnum key, V ifAbsent()) {
    return this.get(key);
  }

  @override
  void addAll(Map<TabEnum, V> other) {
    throw Exception("Cannot modify this map.");
  }

  @override
  V? remove(Object? key) {
    throw Exception("Objects in this map cannot be removed.");
  }

  @override
  void clear() {
    throw Exception("Objects in this map cannot be removed.");
  }

  @override
  void forEach(void action(TabEnum key, V value)) {
    action(TabEnum.one, this.one);
    action(TabEnum.two, this.two);
    action(TabEnum.three, this.three);
  }

  @override
  Iterable<TabEnum> get keys {
    return TabEnum.values;
  }

  @override
  Iterable<V> get values {
    return [
      this.one,
      this.two,
      this.three,
    ];
  }

  @override
  int get length {
    return 3;
  }

  @override
  bool get isEmpty {
    return false;
  }

  @override
  bool get isNotEmpty {
    return true;
  }

  V get(TabEnum key) {
    switch (key) {
      case TabEnum.one:
        return this.one;
      case TabEnum.two:
        return this.two;
      case TabEnum.three:
        return this.three;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer("{");
    buffer.write("TabEnum.one: ${this.one}");
    buffer.write(", ");
    buffer.write("TabEnum.two: ${this.two}");
    buffer.write(", ");
    buffer.write("TabEnum.three: ${this.three}");
    buffer.write("}");
    return buffer.toString();
  }
}
