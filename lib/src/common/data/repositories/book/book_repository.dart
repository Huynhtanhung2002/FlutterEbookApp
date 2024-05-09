import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:xml2json/xml2json.dart';

// Định nghĩa kiểu dữ liệu BookRepositoryData để đại diện cho dữ liệu trả về từ repository
typedef BookRepositoryData = ({CategoryFeed? feed, HttpFailure? failure});

// Lớp trừu tượng BookRepository định nghĩa các phương thức cho việc lấy dữ liệu sách từ một nguồn cụ thể
abstract class BookRepository {
  final Dio httpClient; // Đối tượng Dio sử dụng để thực hiện các yêu cầu HTTP

  // Constructor của lớp
  const BookRepository(this.httpClient);

  // Phương thức getCategory() lấy dữ liệu sách từ một URL danh mục cụ thể
  Future<BookRepositoryData> getCategory(String url) async {
    try {
      final res = await httpClient.get(url); // Thực hiện yêu cầu HTTP đến URL
      CategoryFeed category; // Đối tượng chứa dữ liệu sách
      final Xml2Json xml2json = Xml2Json(); // Đối tượng chuyển đổi XML sang JSON
      xml2json.parse(res.data.toString()); // Chuyển đổi dữ liệu XML sang dạng JSON
      final json = jsonDecode(xml2json.toGData()); // Giải mã JSON thành Map<String, dynamic>
      category = CategoryFeed.fromJson(json as Map<String, dynamic>); // Tạo đối tượng CategoryFeed từ dữ liệu JSON
      return (feed: category, failure: null); // Trả về dữ liệu sách và không có lỗi
    } on DioException catch (error) { // Xử lý các lỗi khi thực hiện yêu cầu HTTP
      final statusCode = error.response?.statusCode ?? 500; // Lấy mã trạng thái HTTP từ phản hồi hoặc mặc định là 500
      if (statusCode == 404) {
        return (feed: null, failure: HttpFailure.notFound); // Trả về null và mã lỗi HttpFailure.notFound
      }
      return (feed: null, failure: HttpFailure.unknown); // Trả về null và mã lỗi HttpFailure.unknown cho các trường hợp khác
    }
  }
}
