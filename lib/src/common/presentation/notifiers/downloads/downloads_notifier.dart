import 'dart:async';

import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'downloads_notifier.g.dart';

@riverpod
class DownloadsNotifier extends _$DownloadsNotifier {
  late DownloadsRepository _repository;

  DownloadsNotifier() : super();

  StreamSubscription<List<Map<String, dynamic>>>? _streamSubscription;

  @override
  Future<List<Map<String, dynamic>>> build() async {
    // khởi tạo và theo dõi dữ liệu tải xuống
    _repository = ref.watch(downloadsRepositoryProvider);
    _listen();
    return _repository.downloadList(); // Trả về danh sách các tệp đã tải xuống từ dữ liệu lưu trữ
  }

  Future<void> _listen() async {
    // theo dõi dữ liệu tải xuống qua luồng
    if (_streamSubscription != null) {
      _streamSubscription!.cancel(); // Hủy đăng ký luồng hiện tại nếu có
      _streamSubscription = null;
    }
    _streamSubscription = (await _repository.downloadListStream()).listen(
      (downloads) => state = AsyncValue.data(downloads), // Lắng nghe dữ liệu từ luồng và cập nhật trạng thái
    );
  }

  Future<void> fetchBook(String id) async {
    // tải sách từ dịch vụ tải xuống
    await _repository.fetchBook(id);
  }

  Future<void> addBook(Map<String, dynamic> book, String id) async {
   // thêm sách vào dữ liệu tải xuống
    await _repository.addBook(book, id);
  }

  Future<void> deleteBook(String id) async {
    // xóa sách khỏi dữ liệu tải xuống
    await _repository.deleteBook(id);
  }

  Future<void> clearBooks() async {
    // xóa tất cả các sách khỏi dữ liệu tải xuống
    await _repository.clearBooks();
  }
}
