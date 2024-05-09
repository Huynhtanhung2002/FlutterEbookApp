import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

// Mixin DatabaseConfig định nghĩa các cấu hình liên quan đến cơ sở dữ liệu
mixin DatabaseConfig {
  // lấy instance của cơ sở dữ liệu dựa trên tên
  static Database getDatabaseInstance(String dbName) {
    // Kiểm tra xem cơ sở dữ liệu có tồn tại không
    final database = _instances[dbName];
    if (database == null) {
      throw Exception('the name provided' ' has no instance available for use');
    }
    return database;
  }

  // khởi tạo cơ sở dữ liệu
  static Future<void> init(StoreRef<dynamic, dynamic> store) async =>
      _initDatabases(
        databaseNames,
        store,
      );

  // Map lưu trữ các instance của cơ sở dữ liệu dựa trên tên
  static final Map<String, Database> _instances = {};

  // khởi tạo cơ sở dữ liệu dựa trên danh sách tên và store
  static Future<void> _initDatabases(
    List<String> dbNames,
    StoreRef<dynamic, dynamic> store,
  ) async {
    for (final name in dbNames) {
      final dbPath = await _generateDbPath(name); //// Tạo đường dẫn của cơ sở dữ liệu
      final dbFactory = kIsWeb ? databaseFactoryWeb : databaseFactoryIo; // Chọn factory dựa trên nền tảng
      final db = await dbFactory.openDatabase(dbPath);
      final databaseReference = _instances[name];
      if (databaseReference != null) await databaseReference.close(); // Đóng cơ sở dữ liệu nếu đã tồn tại
      _instances[name] = db; // Lưu trữ cơ sở dữ liệu vào map
    }
  }

  // Danh sách tên của các cơ sở dữ liệu
  static List<String> get databaseNames => [
        downloadsDatabaseName,
        favoritesDatabaseName,
      ];

  static String get downloadsDatabaseName => 'download.db';

  static String get favoritesDatabaseName => 'favorites11.db';

  // tạo đường dẫn của cơ sở dữ liệu
  static Future<String> _generateDbPath(String dbName) async {
    if (kIsWeb) return dbName; // Trả về tên cơ sở dữ liệu trực tiếp nếu đang chạy trên web
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true); // Tạo thư mục nếu chưa tồn tại
    final dbPath = join(dir.path, dbName); // Nối đường dẫn thư mục ứng dụng và tên cơ sở dữ liệu
    return dbPath;
  }
}
