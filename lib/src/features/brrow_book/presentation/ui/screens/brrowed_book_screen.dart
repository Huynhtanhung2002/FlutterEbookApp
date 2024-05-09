import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class BorrowedBookItem {
  final String id;
  final String title;
  final String author;
  final String imageUrl;

  BorrowedBookItem({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });
}

final borrowedBooksLibraryScreen = StateProvider<List<BorrowedBookItem>>((ref) => []);

@RoutePage()
class BorrowedBooksLibraryScreen extends ConsumerWidget {
  const BorrowedBooksLibraryScreen();

  static const uuid = Uuid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borrowedBooks = ref.watch(borrowedBooksLibraryScreen);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện sách mượn'),
      ),
      body: borrowedBooks.isEmpty
          ? const Center(child: Text('Chưa mượn sách nào'))
          : ListView.builder(
          itemCount: borrowedBooks.length,
          itemBuilder: (context, index) {
          final book = borrowedBooks[index];
          return ListTile(
            leading: Image.network(book.imageUrl),
            title: Text(book.title),
            subtitle: Text('Author: ${book.author}'),
            // Thêm các hành động khác như trả sách, gia hạn mượn tại đây
          );
        },
      ),
    );
  }
}
