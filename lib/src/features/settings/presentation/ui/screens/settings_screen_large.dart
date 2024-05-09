import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';

class SettingsScreenLarge extends StatelessWidget {
  const SettingsScreenLarge({super.key});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem có route con của màn hình cài đặt hay không
    final isNestedEmpty = context.watchRouter.topRoute.name == 'SettingsRoute';

    // tạo hiệu ứng khi chuyển đổi giữa các phần của màn hình
    return AnimatedPageSplitter(
      isExpanded: !isNestedEmpty, // Mở rộng màn hình nếu không có route con
      leftChild: const SettingsScreenSmall(), // Hiển thị màn hình cài đặt nhỏ ở bên trái
      rightChild: const AutoRouter(), // Sử dụng AutoRouter để xử lý các tương tác tiếp theo ở bên phải
    );
  }
}
