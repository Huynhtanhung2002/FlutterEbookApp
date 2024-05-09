import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentTabNotifier extends ValueNotifier<int> {
  CurrentTabNotifier() : super(0);

  // kiểm tra xem tab hiện tại có phải là tab "Home" không.
  bool get isHomeTab => value == 0;

  void changePage(int page) {
    value = page;
    notifyListeners();
  }
}

// Tạo một provider cho CurrentTabNotifier.
final currentTabNotifierProvider = Provider<CurrentTabNotifier>(
  (ref) => CurrentTabNotifier(),
);
