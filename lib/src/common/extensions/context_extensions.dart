import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  Size get screenSize => MediaQuery.sizeOf(this);

  EdgeInsets get screenPadding => MediaQuery.paddingOf(this); // lấy padding của màn hình

  TextScaler get screenTextScaleFactor => MediaQuery.textScalerOf(this);

  bool get isSmallScreen => screenSize.width < 800; // kiểm tra xem màn hình có phải là màn hình nhỏ không

  bool get isMediumScreen =>
      screenSize.width >= 800 && screenSize.width <= 1200; // kiểm tra xem màn hình có phải là màn hình trung bình không

  // kiểm tra xem màn hình có phải là màn hình lớn không
  bool get isLargeScreen => screenSize.width > 800 && !isMediumScreen;

  bool get isPlatformDarkThemed =>
      MediaQuery.platformBrightnessOf(this) == Brightness.dark; // kiểm tra xem chủ đề của nền tảng có phải là chủ đề tối không

  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  // hiển thị một snackbar với nội dung là một đoạn văn bản
  void showSnackBarUsingText(String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
