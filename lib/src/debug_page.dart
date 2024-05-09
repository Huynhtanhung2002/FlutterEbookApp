import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Xác định chế độ tối hay sáng của ứng dụng
    final isDarkMode = ref.watch(currentAppThemeNotifierProvider).value ==
        CurrentAppTheme.dark;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // Tùy chọn để xóa tất cả các sách đã tải xuống
          ListTile(
            title: const Text('Clear Downloads'),
            onTap: () {
              ref.read(downloadsNotifierProvider.notifier).clearBooks();
            },
          ),
          // Tùy chọn để xóa tất cả các sách yêu thích
          ListTile(
            title: const Text('Clear Favorites'),
            onTap: () {
              ref.read(favoritesNotifierProvider.notifier).clearBooks();
            },
          ),
          // Tùy chọn để thay đổi chủ đề của ứng dụng
          ListTile(
            title: Text('Change Theme to ${isDarkMode ? 'Light' : 'Dark'}'),
            onTap: () {
              ref
                  .read(currentAppThemeNotifierProvider.notifier)
                  .updateCurrentAppTheme(!isDarkMode);
            },
          ),
        ],
      ),
    );
  }
}
