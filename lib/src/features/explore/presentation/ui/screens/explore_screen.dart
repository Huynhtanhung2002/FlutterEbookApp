import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';

@RoutePage()
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

 // xây dựng giao diện của trang Explore.
  @override
  Widget build(BuildContext context) {
    // tạo ra một giao diện phản ứng, có thể thay đổi dựa trên kích thước của màn hình.
    return const ResponsiveWidget(
      // Trong trường hợp màn hình nhỏ, hiển thị giao diện của ExploreScreenSmall.
      smallScreen: ExploreScreenSmall(),
      // Trong trường hợp màn hình lớn, hiển thị giao diện của ExploreScreenLarge.
      largeScreen: ExploreScreenLarge(),
    );
  }
}
