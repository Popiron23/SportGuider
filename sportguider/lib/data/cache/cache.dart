// CacheClient - это обертка для работы с локальным хранилищем
// В данном случае используем shared_preferences
import 'package:shared_preferences/shared_preferences.dart';

class CacheClient {
  // Экземпляр SharedPreferences
  final SharedPreferences _sharedPreferences;

  // Конструктор
  CacheClient({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  // Метод для записи данных
  // T - generic тип (обобщенный тип), позволяет работать с разными типами данных
  Future<void> write<T>({required String key, required T value}) async {
    if (value is String) {
      await _sharedPreferences.setString(key, value);
    } else if (value is int) {
      await _sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      await _sharedPreferences.setBool(key, value);
    } else if (value is double) {
      await _sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      await _sharedPreferences.setStringList(key, value);
    } else {
      throw Exception('Тип данных $T не поддерживается');
    }
  }

  // Метод для чтения данных
  T? read<T>({required String key}) {
    // dynamic - специальный тип, который отключает проверку типов на время компиляции
    // Используется когда тип заранее неизвестен
    dynamic value;

    // Проверяем, какой тип данных нужно прочитать
    if (T == String) {
      value = _sharedPreferences.getString(key);
    } else if (T == int) {
      value = _sharedPreferences.getInt(key);
    } else if (T == bool) {
      value = _sharedPreferences.getBool(key);
    } else if (T == double) {
      value = _sharedPreferences.getDouble(key);
    } else if (T == List<String>) {
      value = _sharedPreferences.getStringList(key);
    } else {
      throw Exception('Тип данных $T не поддерживается');
    }

    return value as T?;
  }

  // Метод для удаления данных
  Future<void> delete({required String key}) async {
    await _sharedPreferences.remove(key);
  }

  // Метод для очистки всех данных
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  // Проверка существования ключа
  bool containsKey({required String key}) {
    return _sharedPreferences.containsKey(key);
  }
}
