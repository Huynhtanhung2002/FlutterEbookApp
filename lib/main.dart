import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/app.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init(); // Quản lý lưu trữ dữ liệu cục bộ.
  // Cấu hình cơ sở dữ liệu bằng cách gọi phương thức init từ DatabaseConfig
  await DatabaseConfig.init(StoreRef<dynamic, dynamic>.main());
  runApp(
    ProviderScope(
      observers: [RiverpodObserver()],
      child: MyApp(),
    ),
  );
}
