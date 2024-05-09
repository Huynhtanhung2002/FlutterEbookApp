import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreRepository extends BookRepository {
  ExploreRepository(super.httpClient); // Constructor của lớp nhận một tham số là `httpClient` từ lớp cha.

  Future<BookRepositoryData> getGenreFeed(  // lấy dữ liệu về các thể loại sách dựa trên một URL nhất định.
    String url,
  ) {
    final String stripedUrl = url.replaceAll(baseURL, '');  // Loại bỏ phần cơ sở của URL để chuẩn hóa đường dẫn.
    final successOrFailure = getCategory(stripedUrl); // lấy dữ liệu từ URL đã chuẩn hóa.
    return successOrFailure;
  }
}

final exploreRepositoryProvider =
    Provider.autoDispose<ExploreRepository>((ref) { // Định nghĩa một provider Riverpod kiểu autoDispose, tự động hủy khi không còn cần thiết.
  final dio = ref.watch(dioProvider); // Lấy đối tượng `dioProvider` từ context để sử dụng.
  return ExploreRepository(dio); // Trả về một đối tượng ExploreRepository mới, được khởi tạo với dioProvider đã lấy được.
});
