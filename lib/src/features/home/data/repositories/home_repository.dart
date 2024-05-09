import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class HomeRepository extends BookRepository {
  HomeRepository(super.httpClient); // Constructor của HomeRepository, nhận httpClient làm tham số

  //lấy dữ liệu về sách phổ biến
  Future<BookRepositoryData> getPopularHomeFeed() {
    final successOrFailure = getCategory(popular); // Lấy dữ liệu từ nguồn phổ biến
    return successOrFailure; // Trả về kết quả lấy được
  }

  // lấy dữ liệu về sách mới nhất
  Future<BookRepositoryData> getRecentHomeFeed() {
    final successOrFailure = getCategory(recent); // Lấy dữ liệu từ nguồn sách mới nhất
    return successOrFailure; // trả về kết quả nhận được
  }
}

final homeRepositoryProvider = Provider.autoDispose<HomeRepository>((ref) {
  final dio = ref.watch(dioProvider); // Lấy instance của httpClient từ dioProvider
  return HomeRepository(dio); // Trả về một instance của HomeRepository được khởi tạo với httpClient
});
