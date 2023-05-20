import 'package:meta/meta.dart';

@immutable
class _TypePair {
  const _TypePair({
    required this.source,
    required this.destination,
  });

  /// The source [Type].
  final Type source;

  /// The destination [Type].
  final Type destination;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _TypePair &&
        other.source == source &&
        other.destination == destination;
  }

  @override
  int get hashCode => source.hashCode ^ destination.hashCode;
}

/// {@template type_map_not_registered}
/// An [Exception] for when a mapping has not been registered.
/// {@endtemplate}
class TypeMapNotRegistered<S, D> implements Exception {
  /// {@macro type_map_not_registered}
  TypeMapNotRegistered()
      : message = 'A type mapping does not exist for $S -> $D';

  /// Message to be printed for this [Exception].
  final String message;

  @override
  String toString() {
    return message;
  }
}

/// {@template type_map_not_registered}
/// An [Exception] for when a mapping has already been registered.
/// {@endtemplate}
class TypeMapAlreadyRegistered<S, D> implements Exception {
  /// {@macro type_map_not_registered}
  TypeMapAlreadyRegistered()
      : message = 'A type mapping already exists for $S -> $D';

  /// Message to be printed for this [Exception].
  final String message;

  @override
  String toString() {
    return message;
  }
}

/// Function typedef representing a mapping between types [S] and [D].
typedef Mapping<S extends Object, D extends Object> = D Function(S source);

/// {@template type_mapper}
/// A simple service for registering a mapping between two types.
///
/// This is an alternative to creating extension methods on individual types.
/// {@endtemplate}
class TypeMapper {
  TypeMapper._();

  static final TypeMapper _instance = TypeMapper._();

  /// {@macro type_mapper}
  ///
  /// Returns a singleton instance of [TypeMapper].
  static TypeMapper get instance => _instance;

  /// {@macro type_mapper}
  ///
  /// Returns a singleton instance of [TypeMapper].
  static TypeMapper get I => _instance;

  final Map<_TypePair, dynamic> _typeMap = {};

  /// Returns true if a mapping exists between types [S] and [D].
  bool isRegistered<S extends Object, D extends Object>() =>
      _typeMap[_TypePair(source: S, destination: D)] != null;

  /// Register a mapping bewteen the source type [S]
  /// and the destination type [D].
  void registerMapping<S extends Object, D extends Object>(
    Mapping<S, D> mapping,
  ) {
    if (isRegistered<S, D>()) {
      throw TypeMapAlreadyRegistered<S, D>();
    }

    _typeMap[_TypePair(
      source: S,
      destination: D,
    )] = mapping;
  }

  /// Returns the result of mapping type [S] to type [D].
  D map<S extends Object, D extends Object>(S source) {
    final pair = _TypePair(
      source: S,
      destination: D,
    );
    final mapping = _typeMap[pair] as Mapping<S, D>?;
    if (mapping == null) throw TypeMapNotRegistered<S, D>();
    return mapping(source);
  }

  /// Resets all currently registered mappings.
  void reset() {
    _typeMap.clear();
  }
}
