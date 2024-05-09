import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

// Provider cho tham chiếu của thư viện Sembast
final storeRefProvider = Provider<StoreRef<String, Map<String, dynamic>>>(
  (ref) => StoreRef<String, Map<String, dynamic>>.main(), // Tạo một tham chiếu của cửa hàng chính
);

// Provider cho cơ sở dữ liệu tải xuống
final downloadsDatabaseProvider = Provider<Database>(
  (ref) => DatabaseConfig.getDatabaseInstance( // Tạo một phiên bản của cơ sở dữ liệu tải xuống
    DatabaseConfig.downloadsDatabaseName, // Sử dụng tên cơ sở dữ liệu tải xuống từ cấu hình
  ),
);

// Provider cho cơ sở dữ liệu yêu thích
final favoritesDatabaseProvider = Provider<Database>(
  (ref) => DatabaseConfig.getDatabaseInstance( // Tạo một phiên bản của cơ sở dữ liệu yêu thích
    DatabaseConfig.favoritesDatabaseName, // Sử dụng tên cơ sở dữ liệu yêu thích từ cấu hình
  ),
);
