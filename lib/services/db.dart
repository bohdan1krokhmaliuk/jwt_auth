import 'package:collection/collection.dart';

/// Class that emulates database service
class DatabaseService {
  DatabaseService._();

  /// Default constructor for class that emulates database service
  factory DatabaseService.instance() => _instance ??= DatabaseService._();
  static DatabaseService? _instance;

  final Map<Type, List<dynamic>> _localDb = {};

  /// Emulates save [object] to db (actually saves into ram)
  Future<void> insert<T>(T object) async {
    _getTable<T>().add(object);
  }

  /// Emulates save all [objects] to db (actually saves into ram)
  Future<void> insertAll<T>(List<T> objects) async {
    _getTable<T>().addAll(objects);
  }

  /// Emulates delete object from db which conform where
  /// (actually deletes from ram)
  Future<void> delete<T>(WhereQuery<T> where) async {
    _getTable<T>().removeWhere(where);
  }

  /// Emulates get single object from db (actually sames into ram)
  Future<T?> get<T>(WhereQuery<T> where) async {
    try {
      return _getTable<T>().firstWhereOrNull(where);
    } catch (e) {
      return null;
    }
  }

  /// Emulates get where from db (actually sames into ram)
  Future<List<T>> getAll<T>({WhereQuery<T>? where}) async {
    final values = _getTable<T>();
    return where != null ? values.where(where).toList() : values;
  }

  List<T> _getTable<T>() => (_localDb[T] ??= <T>[]) as List<T>;
}

/// Where callback
typedef WhereQuery<T> = bool Function(T element);
