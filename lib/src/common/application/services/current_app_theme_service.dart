import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service để quản lý chủ đề hiện tại của ứng dụng
class CurrentAppThemeService {
  final SharedPreferences? _sharedPreferences; // SharedPreferences để lưu trữ thông tin chủ đề

  const CurrentAppThemeService(this._sharedPreferences); // Constructor nhận SharedPreferences

  // Phương thức để thiết lập chủ đề hiện tại của ứng dụng
  Future<bool> setCurrentAppTheme(bool isDarkMode) =>
      _sharedPreferences!.setBool(
        isDarkModeKey,
        isDarkMode,
      );

  // Phương thức để lấy chủ đề hiện tại của ứng dụng
  CurrentAppTheme getCurrentAppTheme() {
    final isDarkMode = _sharedPreferences!.getBool(isDarkModeKey);
    // Nếu không có giá trị được lưu, trả về chủ đề mặc định là sáng
    return (isDarkMode ?? false) ? CurrentAppTheme.dark : CurrentAppTheme.light;
  }

  // Phương thức để kiểm tra chủ đề hiện tại của ứng dụng
  bool getIsDarkMode() {
    final isDarkMode = _sharedPreferences!.getBool(isDarkModeKey);
    // Nếu không có giá trị được lưu, trả về false (chủ đề sáng)
    return isDarkMode ?? false;
  }
}

// Provider để cung cấp một instance của CurrentAppThemeService
final currentAppThemeServiceProvider = Provider<CurrentAppThemeService>(
  (ref) {
    // Sử dụng Provider của sharedPreferencesProvider để nhận SharedPreferences
    // cần thiết để khởi tạo một instance của CurrentAppThemeService
    return CurrentAppThemeService(ref.watch(sharedPreferencesProvider));
  },
);
