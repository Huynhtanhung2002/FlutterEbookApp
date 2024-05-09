import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimeout() {
    Timer(const Duration(seconds: 2), handleTimeout); // Đếm thời gian trong 2 giây trước khi gọi handleTimeout
  }

  void handleTimeout() {
    changeScreen(); // Chuyển đến màn hình tiếp theo
  }

  Future<void> changeScreen() async {
    // Thay thế màn hình hiện tại bằng màn hình TabsRoute
    context.router.replace(const LoginRoute()); // LoginRoute()
  }

  @override
  void initState() {
    super.initState();
    startTimeout(); // Bắt đầu đếm thời gian khi initState được gọi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/app-icon.png',
              height: 300.0,
              width: 300.0,
            ),
          ],
        ),
      ),
    );
  }
}
