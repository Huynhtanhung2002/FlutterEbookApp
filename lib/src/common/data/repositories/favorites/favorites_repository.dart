import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Lớp trừu tượng FavoritesRepository định nghĩa các phương thức cho việc quản lý danh sách yêu thích
abstract class FavoritesRepository {
  const FavoritesRepository();

  // thêm sách vào danh sách yêu thích
  Future<void> addBook(Entry book, String id);

  // xóa sách khỏi danh sách yêu thích dựa trên id
  Future<void> deleteBook(String id);

  // lấy stream của danh sách các sách trong danh sách yêu thích
  Future<Stream<List<Entry>>> favoritesListStream();

  // xóa tất cả các sách trong danh sách yêu thích
  Future<void> clearBooks();
}

// Lớp FavoritesRepositoryImpl triển khai các phương thức của FavoritesRepository
class FavoritesRepositoryImpl extends FavoritesRepository {
  final FavoritesLocalDataSource localDataSource; // Đối tượng localDataSource để tương tác với dữ liệu cục bộ

  const FavoritesRepositoryImpl({
    required this.localDataSource,
  });

  // Ghi đè phương thức thêm sách vào danh sách yêu thích
  @override
  Future<void> addBook(Entry book, String id) async {
    await localDataSource.addBook(book, id);
  }

  // Ghi đè phương thức xóa sách khỏi danh sách yêu thích dựa trên id
  @override
  Future<void> deleteBook(String id) async {
    await localDataSource.deleteBook(id);
  }

  // Ghi đè phương thức lấy stream của danh sách các sách trong danh sách yêu thích
  @override
  Future<Stream<List<Entry>>> favoritesListStream() async {
    return localDataSource.favoritesListStream();
  }

  // Ghi đè phương thức xóa tất cả các sách trong danh sách yêu thích
  @override
  Future<void> clearBooks() async {
    await localDataSource.clearBooks();
  }
}

// Provider tự động hủy favoritesRepositoryProvider cung cấp một instance của FavoritesRepositoryImpl
final favoritesRepositoryProvider = Provider.autoDispose<FavoritesRepository>(
      (ref) {
    final localDataSource = ref.watch(favoritesLocalDataSourceProvider); // Lấy đối tượng localDataSource từ Provider
    return FavoritesRepositoryImpl(localDataSource: localDataSource); // Trả về một instance của FavoritesRepositoryImpl
  },
);
