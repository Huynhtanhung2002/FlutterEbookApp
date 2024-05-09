import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider cho SharedPreferences instance, một cách để lưu trữ và truy xuất dữ liệu cục bộ
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => LocalStorage().getSharedPreferences()!, // Tạo một thể hiện của SharedPreferences thông qua LocalStorage
);
