import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Lớp trừu tượng DownloadsRepository định nghĩa các phương thức cho việc quản lý dữ liệu tải xuống
abstract class DownloadsRepository {
  const DownloadsRepository(); // Constructor của lớp

  //thêm sách vào danh sách tải xuống
  Future<void> addBook(Map<String, dynamic> book, String id);

  //xóa sách khỏi danh sách tải xuống dựa trên id
  Future<void> deleteBook(String id);

  // xóa tất cả các sách có cùng id khỏi danh sách tải xuống
  Future<void> deleteAllBooksWithId(String id);

  // lấy danh sách các sách đang được tải xuống
  Future<List<Map<String, dynamic>>> downloadList();

  // lấy thông tin sách từ danh sách tải xuống dựa trên id
  Future<Map<String, dynamic>?> fetchBook(String id);

  // lấy stream của danh sách sách đang được tải xuống
  Future<Stream<List<Map<String, dynamic>>>> downloadListStream();

  // xóa tất cả các sách trong danh sách tải xuống
  Future<void> clearBooks();
}

// Lớp DownloadsRepositoryImpl triển khai các phương thức của DownloadsRepository
class DownloadsRepositoryImpl extends DownloadsRepository {
  final DownloadsLocalDataSource localDataSource; // Đối tượng localDataSource để tương tác với dữ liệu cục bộ

  // Constructor của lớp
  const DownloadsRepositoryImpl({
    required this.localDataSource,
  });

  // Ghi đè phương thức thêm sách vào danh sách tải xuống
  @override
  Future<void> addBook(Map<String, dynamic> book, String id) async {
    await localDataSource.addBook(book, id);
  }

  // Ghi đè phương thức xóa sách khỏi danh sách tải xuống dựa trên id
  @override
  Future<void> deleteBook(String id) async {
    await localDataSource.deleteBook(id);
  }

  // Ghi đè phương thức xóa tất cả các sách có cùng id khỏi danh sách tải xuống
  @override
  Future<void> deleteAllBooksWithId(String id) async {
    await localDataSource.deleteAllBooksWithId(id);
  }

  // Ghi đè phương thức lấy danh sách các sách đang được tải xuống
  @override
  Future<List<Map<String, dynamic>>> downloadList() async {
    return localDataSource.downloadList();
  }

  // Ghi đè phương thức lấy thông tin sách từ danh sách tải xuống dựa trên id
  @override
  Future<Map<String, dynamic>?> fetchBook(String id) async {
    return localDataSource.fetchBook(id);
  }

  // Ghi đè phương thức lấy stream của danh sách sách đang được tải xuống
  @override
  Future<Stream<List<Map<String, dynamic>>>> downloadListStream() async {
    return localDataSource.downloadListStream();
  }

  // Ghi đè phương thức xóa tất cả các sách trong danh sách tải xuống
  @override
  Future<void> clearBooks() async {
    await localDataSource.clearBooks();
  }
}

// Provider tự động hủy downloadsRepositoryProvider cung cấp một instance của DownloadsRepositoryImpl
final downloadsRepositoryProvider = Provider.autoDispose<DownloadsRepository>(
      (ref) {
    final localDataSource = ref.watch(downloadsLocalDataSourceProvider); // Lấy đối tượng localDataSource từ Provider
    return DownloadsRepositoryImpl(localDataSource: localDataSource); // Trả về một instance của DownloadsRepositoryImpl
  },
);
