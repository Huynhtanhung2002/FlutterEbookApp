import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _passwordController = TextEditingController(); // Thêm controller cho mật khẩu

  @override
  void dispose() {
    _passwordController.dispose(); // Hủy bỏ controller khi không cần thiết nữa
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student ID',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              '123456', // Hiển thị Student ID tại đây, có thể thay bằng dữ liệu thực tế từ provider hoặc database
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter new password',
              ),
              obscureText: true, // Ẩn mật khẩu
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle saving the edited password here
                final String newPassword = _passwordController.text; // Lấy dữ liệu từ TextField mật khẩu

                // Perform operations like updating the user's password
                // You can also navigate back to the previous screen
                Navigator.pop(context);
              },
              child: const Text('Save Password'),
            ),
          ],
        ),
      ),
    );
  }
}
