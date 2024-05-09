import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logman/logman.dart';
import 'package:sembast/sembast.dart';

class DownloadsLocalDataSourceImpl implements DownloadsLocalDataSource {
  final Database _database;
  final StoreRef<String, Map<String, dynamic>> _store; // StoreRef để thao tác với dữ liệu trong database

  // Constructor
  const DownloadsLocalDataSourceImpl({
    required Database database,
    required StoreRef<String, Map<String, dynamic>> store,
  })  : _database = database,
        _store = store;

  // thêm một cuốn sách vào danh sách tải về
  @override
  Future<void> addBook(Map<String, dynamic> book, String id) async {
    await _store.record(id).put(_database, book, merge: true);
    // Ghi log về việc thêm cuốn sách vào danh sách tải về
    Logman.instance.recordSimpleLog(
      'Added book to brrow_book: ${book['title']}',
    );
  }

  // xóa tất cả các cuốn sách trong danh sách tải về
  @override
  Future<void> clearBooks() async {
    await _store.delete(_database); // Xóa tất cả dữ liệu trong store
    Logman.instance.recordSimpleLog(
      'Cleared all books from brrow_book',
    );
  }

  // xóa tất cả các cuốn sách có cùng id trong danh sách tải về
  @override
  Future<void> deleteAllBooksWithId(String id) async {
    await _store.record(id).delete(_database);  // Xóa các bản ghi có id tương ứng trong store
    Logman.instance.recordSimpleLog(
      'Deleted all books with id: $id',
    );
  }

  // xóa một cuốn sách khỏi danh sách tải về
  @override
  Future<void> deleteBook(String id) async {
    await _store.record(id).delete(_database); // Xóa bản ghi có id tương ứng trong store
    Logman.instance.recordSimpleLog(
      'Deleted book from brrow_book: $id',
    );
  }

  // lấy danh sách các cuốn sách đã tải về
  @override
  Future<List<Map<String, dynamic>>> downloadList() async {
    // Chuyển đổi thành List<Map<String, dynamic>> và trả về
    return _store.query().getSnapshots(_database).then(
          (records) => records.map((record) => record.value).toList(),
        );
  }

  // lấy thông tin của một cuốn sách từ danh sách tải về
  @override
  Future<Map<String, dynamic>?> fetchBook(String id) async {
    Logman.instance.recordSimpleLog(
      'Fetched book from brrow_book: $id',
    );
    // Lấy thông tin của cuốn sách có id tương ứng từ store trong database
    return _store.record(id).get(_database);
  }

  // Thêm phương thức mượn sách vào lớp DownloadsLocalDataSourceImpl
  Future<void> borrowBook(Map<String, dynamic> book, String id) async {
    await _store.record(id).put(_database, book, merge: true);
    Logman.instance.recordSimpleLog(
      'Borrowed book: ${book['title']}',
    );
  }


  // lấy một Stream của danh sách các cuốn sách đã tải về
  @override
  Stream<List<Map<String, dynamic>>> downloadListStream() {
    // Lắng nghe sự thay đổi trong store và trả về một Stream của danh sách các cuốn sách
    return _store
        .query()
        .onSnapshots(_database)
        .map<List<Map<String, dynamic>>>(
          (records) => records
              .map<Map<String, dynamic>>((record) => record.value)
              .toList(),
        );
  }
}

// Provider để cung cấp một instance của DownloadsLocalDataSource
final downloadsLocalDataSourceProvider =
    Provider.autoDispose<DownloadsLocalDataSource>(
  (ref) {
    // Lấy database và store từ các Provider tương ứng
    final database = ref.watch(downloadsDatabaseProvider);
    final store = ref.watch(storeRefProvider);
    // Trả về một instance mới của DownloadsLocalDataSourceImpl
    return DownloadsLocalDataSourceImpl(database: database, store: store);
  },
);
