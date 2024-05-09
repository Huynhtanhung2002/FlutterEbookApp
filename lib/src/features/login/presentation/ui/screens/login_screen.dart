import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/login/presentation/ui/screens/logout_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


// Lớp User đại diện cho thông tin của người dùng
class User {
  final String username;
  final String token;

  User({required this.username, required this.token});
}

// Provider quản lý trạng thái đăng nhập của người dùng
class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  // Phương thức để đăng nhập
  void login(String username, String password) async {
    // Tạo một yêu cầu POST đến API đăng nhập với tên người dùng và mật khẩu
    var url = Uri.parse('66189e819a41b1b3dfbd8368.mockapi.io/api/v1/user-service/login');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    // Kiểm tra mã trạng thái của phản hồi
    if (response.statusCode == 200) {
      // Nếu đăng nhập thành công, lấy token từ phản hồi và lưu vào AuthProvider
      var token = response.body; // Giả sử token được trả về là một string
      _user = User(username: username, token: token);
      notifyListeners();
    } else {
      // Nếu có lỗi, xử lý tùy thuộc vào mã trạng thái
      // Ví dụ: hiển thị thông báo lỗi
      print('Đăng nhập không thành công: ${response.statusCode}');
    }
  }

  // Phương thức để đăng xuất
  void logout() {
    _user = null;
    notifyListeners();
  }
}

// Widget chính cho màn hình đăng nhập
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Widget hiển thị giao diện đăng nhập
class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  labelStyle: TextStyle(color: Colors.blue), // Thay đổi màu sắc của labelText
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Thay đổi màu sắc và độ dày của viền khi TextField được focus
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Thay đổi màu sắc của viền khi TextField không được focus
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.blue), // Thay đổi màu sắc của labelText
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Thay đổi màu sắc và độ dày của viền khi TextField được focus
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Thay đổi màu sắc của viền khi TextField không được focus
                  ),
                ),
                obscureText: true, // Ẩn mật khẩu
              ),

              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  String username = _usernameController.text.trim();
                  String password = _passwordController.text.trim();
                  // Kiểm tra xem tên người dùng và mật khẩu có được nhập không
                  if (username.isNotEmpty && password.isNotEmpty) {
                    // Nếu có, thực hiện đăng nhập và điều hướng đến trang chính
                    Provider.of<AuthProvider>(context, listen: false).login(username, password);
                    AutoRouter.of(context).push(
                      const TabsRoute(), // Điều hướng đến trang chính sau khi đăng nhập thành công
                    );
                  } else {
                    // Nếu không, hiển thị hộp thoại cảnh báo
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Lỗi'),
                          content: const Text('Vui lòng nhập tên người dùng và mật khẩu.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget cho trang chính sau khi đăng nhập thành công
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  authProvider.logout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogoutScreen()),
                  );
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Center(
            child: authProvider.isLoggedIn
                ? Text('Welcome, ${authProvider.user!.username}!')
                : const Text('Please log in'),
          ),
        );
      },
    );
  }
}


