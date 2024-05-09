import 'package:shared_preferences/shared_preferences.dart';

// Định nghĩa một lớp LocalStorage để quản lý lưu trữ cục bộ trên thiết bị
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._privateConstructor();
  factory LocalStorage() => _instance;

  SharedPreferences? _prefs;

  LocalStorage._privateConstructor();

  // Phương thức init để khởi tạo SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences? getSharedPreferences() {
    return _prefs;
  }
}