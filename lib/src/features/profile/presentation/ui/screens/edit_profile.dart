import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker(); // Create an instance of ImagePicker
  final TextEditingController _passwordController = TextEditingController(); // Thêm controller cho mật khẩu

  @override
  void dispose() {
    _passwordController.dispose(); // Hủy bỏ controller khi không cần thiết nữa
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Use pickImage instead of getImage

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
            GestureDetector(
              onTap: getImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50, // Đặt bán kính cho avatar
                    backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/images/empty.png') as ImageProvider<Object>,
                    child: _image == null ? const Icon(Icons.camera_alt) : null,
                  ),
                  if (_image != null) // Kiểm tra xem đã chọn ảnh chưa
                    const Positioned.fill(
                      child: Opacity(
                        opacity: 0.8,
                        child: Icon(Icons.camera_alt), // Hiển thị biểu tượng máy ảnh mờ
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Student ID',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              '123456', // Hiển thị Student ID tại đây, có thể thay bằng dữ liệu thực tế từ provider hoặc database
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Avatar
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
