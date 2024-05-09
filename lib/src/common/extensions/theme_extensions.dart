import 'package:flutter/material.dart';

// Extension trên ThemeData để cung cấp các phương thức tiện ích cho việc làm việc với chủ đề
extension ThemeExtensions on ThemeData {
  // lấy màu nhấn của chủ đề
  Color get accentColor => colorScheme.secondary;

  //kiểm tra xem chủ đề có phải là chủ đề tối không
  bool get isDark => brightness == Brightness.dark;
}
