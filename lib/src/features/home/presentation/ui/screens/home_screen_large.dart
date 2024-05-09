import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';

class HomeScreenLarge extends StatelessWidget {
  const HomeScreenLarge({super.key});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem có trang con không
    final isNestedEmpty = context.watchRouter.topRoute.name == 'HomeRoute';

    return AnimatedPageSplitter(
      isExpanded: !isNestedEmpty,  // Thiết lập trạng thái mở rộng dựa trên việc có trang con hay không
      leftChild: const HomeScreenSmall(), // Widget bên trái là HomeScreenSmall
      rightChild: const AutoRouter(),  // Widget bên phải là AutoRouter để xử lý định tuyến tự động
    );
  }
}
