import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_app_theme_notifier.g.dart';

@riverpod
class CurrentAppThemeNotifier extends _$CurrentAppThemeNotifier {
  late CurrentAppThemeService _currentAppThemeService;

  CurrentAppThemeNotifier() : super();

  // cập nhật chủ đề ứng dụng hiện tại
  Future<void> updateCurrentAppTheme(bool isDarkMode) async {
    final success =
        await _currentAppThemeService.setCurrentAppTheme(isDarkMode); // Đặt chủ đề dựa trên boolean được cung cấp

    if (success) {
      state = AsyncValue.data( // thành công, cập nhật trạng thái chủ đề mới
        isDarkMode ? CurrentAppTheme.dark : CurrentAppTheme.light,
      );
    }
  }

  @override
  Future<CurrentAppTheme> build() async {
    _currentAppThemeService = ref.read(currentAppThemeServiceProvider); // Khởi tạo dịch vụ bằng cách đọc nó
    return _currentAppThemeService.getCurrentAppTheme(); // Trả về chủ đề ứng dụng hiện tại
  }
}

enum CurrentAppTheme {
  light(ThemeMode.light), // Chủ đề sáng
  dark(ThemeMode.dark); // Chủ đề tối

  final ThemeMode themeMode; // Chế độ chủ đề
  const CurrentAppTheme(this.themeMode);
}
