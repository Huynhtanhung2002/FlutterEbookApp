import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logman/logman.dart';

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key); // Thêm Key? key vào constructor của MyApp

  final _appRouter = AppRouter(); // Truyền navigatorKey vào AppRouter

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theo dõi sự thay đổi trong currentAppThemeNotifierProvider
    final currentAppTheme = ref.watch(currentAppThemeNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appName,
      // Đặt chủ đề dựa trên giá trị của currentAppThemeNotifierProvider
      theme: themeData(
        currentAppTheme.value == CurrentAppTheme.dark ? darkTheme : lightTheme,
      ),
      darkTheme: themeData(darkTheme),
      themeMode: currentAppTheme.value?.themeMode,
      routerDelegate: _appRouter.delegate(), // Sử dụng delegate() thay vì config()
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: lightAccent,
      ),
    );
  }
}
