import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/provider/user_data_provider.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // Làm sạch dữ liệu người dùng cục bộ và chuyển hướng đến màn hình đăng nhập.
      await _doLogoutAsync(
        userDataProvider: context.read<UserDataProvider>(),
        onSuccess: () => _onLogoutSuccess(context),
      );
    });
  }

  Future<void> _doLogoutAsync({
    required UserDataProvider userDataProvider,
    required VoidCallback onSuccess,
  }) async {
    await userDataProvider.clearUserDataAsync();

    onSuccess.call();
  }

  void _onLogoutSuccess(BuildContext context) {
    // Sử dụng hàm navigate từ AutoRouter để điều hướng đến màn hình đăng nhập.
    AutoRouter.of(context).replace(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
