import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/book_details/data/repositories/book_details_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_details_notifier.g.dart';

@riverpod
class BookDetailsNotifier extends _$BookDetailsNotifier {
  late BookDetailsRepository _bookDetailsRepository; // Repository cho dữ liệu chi tiết sách

  late String _url;

  BookDetailsNotifier(); // Hàm khởi tạo

  @override
  // gọi khi cần khởi tạo trạng thái ban đầu hoặc cần cập nhật dữ liệu dựa trên URL được cung cấp
  Future<CategoryFeed> build(String url) async {
    _bookDetailsRepository = ref.watch(bookDetailsRepositoryProvider); // Lấy tham chiếu đến repository từ Provider
    _url = url;
    return _fetch(); // Gọi hàm _fetch để tải dữ liệu
  }

  // fetch để tải dữ liệu
  Future<void> fetch() async {
    state = const AsyncValue.loading(); // Đặt trạng thái là đang tải
    state = AsyncValue.data(await _fetch());  // Gán dữ liệu trả về từ _fetch vào trạng thái
  }

  // thực hiện tải dữ liệu từ repository
  Future<CategoryFeed> _fetch() async {
    state = const AsyncValue.loading();
    // Gửi yêu cầu tải dữ liệu từ repository
    final successOrFailure = await _bookDetailsRepository.getRelatedFeed(_url);

    final success = successOrFailure.feed; // Dữ liệu tải thành công
    final failure = successOrFailure.failure; // Lỗi nếu có

    if (failure is HttpFailure) {
      throw failure.description; // Ném ngoại lệ nếu có lỗi HTTP
    }
    return success!; // Trả về dữ liệu tải thành công
  }
}
