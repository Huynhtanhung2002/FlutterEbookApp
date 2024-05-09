import 'dart:math';

String formatBytes(int bytes, int decimals) {
  if (bytes == 0) return '0.0';
  const k = 1024;
  final dm = decimals <= 0 ? 0 : decimals; // Xác định số lượng chữ số sau dấu thập phân trong kết quả chuyển đổi
  // Khai báo một list sizes chứa các đơn vị kích thước dữ liệu từ byte đến yottabyte
  final sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  // Tính toán kích thước dữ liệu trong đơn vị phù hợp và định dạng số thập phân theo decimals
  // Nối chuỗi kích thước với đơn vị tương ứng từ list sizes để tạo ra chuỗi kết quả
  final i = (log(bytes) / log(k)).floor();
  return '${(bytes / pow(k, i)).toStringAsFixed(dm)} ${sizes[i]}';
}
