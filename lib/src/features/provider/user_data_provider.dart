import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Định nghĩa lớp StorageKeys để lưu trữ các khóa SharedPreferences
class StorageKeys {
  static const String username = 'username'; // Khóa cho tên người dùng
  static const String userProfileImageUrl = 'userProfileImageUrl'; // Khóa cho URL hình ảnh hồ sơ người dùng
  static const String auth = 'auth'; // Khóa cho thông tin xác thực
}

// Lớp UserDataProvider quản lý dữ liệu người dùng
class UserDataProvider extends ChangeNotifier {
  var _userProfileImageUrl = ''; // URL hình ảnh hồ sơ mặc định
  var _username = ''; // Tên người dùng mặc định
  var _auth = ''; // Thông tin xác thực mặc định

  String get userProfileImageUrl => _userProfileImageUrl; // Getter cho URL hình ảnh hồ sơ
  String get username => _username; // Getter cho tên người dùng
  String get auth => _auth; // Getter cho thông tin xác thực

  // Phương thức để tải dữ liệu từ SharedPreferences
  Future<void> loadAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    // Đọc dữ liệu từ SharedPreferences và gán cho các biến tương ứng
    _username = sharedPref.getString(StorageKeys.username) ?? '';
    _userProfileImageUrl = sharedPref.getString(StorageKeys.userProfileImageUrl) ?? '';
    _auth = sharedPref.getString(StorageKeys.auth) ?? '';

    notifyListeners(); // Thông báo cho người nghe rằng dữ liệu đã được cập nhật
  }

  // Phương thức để lưu trữ dữ liệu người dùng vào SharedPreferences
  Future<void> setUserDataAsync({
    String? userProfileImageUrl,
    String? username,
    String? auth,
  }) async {
    final sharedPref = await SharedPreferences.getInstance();
    var shouldNotify = false; // Biến để kiểm tra xem có cần thông báo cho người nghe không

    // Cập nhật dữ liệu mới nếu có thay đổi
    if (userProfileImageUrl != null && userProfileImageUrl != _userProfileImageUrl) {
      _userProfileImageUrl = userProfileImageUrl;
      await sharedPref.setString(StorageKeys.userProfileImageUrl, _userProfileImageUrl);
      shouldNotify = true; // Có thay đổi, cần thông báo
    }

    if (username != null && username != _username) {
      _username = username;
      await sharedPref.setString(StorageKeys.username, _username);
      shouldNotify = true;
    }

    if (auth != null && auth != _auth) {
      _auth = auth;
      await sharedPref.setString(StorageKeys.auth, _auth);
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners(); // Thông báo cho người nghe rằng dữ liệu đã được cập nhật
    }
  }

  // Phương thức để xóa dữ liệu người dùng từ SharedPreferences
  Future<void> clearUserDataAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    // Xóa dữ liệu từ SharedPreferences và gán giá trị mặc định cho các biến
    await sharedPref.remove(StorageKeys.username);
    await sharedPref.remove(StorageKeys.userProfileImageUrl);
    await sharedPref.remove(StorageKeys.auth);

    _username = '';
    _userProfileImageUrl = '';
    _auth = '';

    notifyListeners(); // Thông báo cho người nghe rằng dữ liệu đã được cập nhật
  }

  // Phương thức kiểm tra xem người dùng đã đăng nhập hay chưa
  bool isUserLoggedIn() {
    return _username.isNotEmpty; // Trả về true nếu tên người dùng không rỗng
  }
}
