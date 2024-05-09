import 'package:dio/dio.dart';
import 'package:dio/io.dart';

// Định nghĩa hàm getAdapter để trả về một đối tượng HttpClientAdapter
HttpClientAdapter getAdapter() {
  // Trả về một instance của IOHttpClientAdapter, là adapter HTTP được sử dụng trong môi trường Dart IO
  return IOHttpClientAdapter();
}
