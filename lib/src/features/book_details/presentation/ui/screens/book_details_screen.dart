import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class BorrowedBook {
  final String id;
  final String title;
  final String author;
  final String imageUrl;

  BorrowedBook({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });
}

final borrowedBooksProvider = StateProvider<List<BorrowedBook>>((ref) => []);

@RoutePage()
class BorrowedBooksScreen extends ConsumerWidget {
  const BorrowedBooksScreen({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borrowedBooks = ref.watch(borrowedBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowed Books'),
      ),
      body: borrowedBooks.isEmpty
          ? const Center(child: Text('No books borrowed yet'))
          : ListView.builder(
        itemCount: borrowedBooks.length,
        itemBuilder: (context, index) {
          final book = borrowedBooks[index];
          return ListTile(
            leading: Image.network(book.imageUrl),
            title: Text(book.title),
            subtitle: Text('Author: ${book.author}'),
          );
        },
      ),
    );
  }
}

class BookDetailsScreen extends ConsumerStatefulWidget {
  final Entry entry;
  final String imgTag;
  final String titleTag;
  final String authorTag;

  static const uuid = Uuid();

  const BookDetailsScreen({
    required this.entry,
    required this.imgTag,
    required this.titleTag,
    required this.authorTag,
  });

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  late List<BorrowedBook> borrowedBooks = [];
  int selectedDays = 1;
  int selectedQuantity = 1;

  void addBorrowedBook(BorrowedBook borrowedBook) {
    setState(() {
      borrowedBooks = [
        ...borrowedBooks,
        borrowedBook,
      ];
    });
    ref.read(borrowedBooksProvider.notifier).state = borrowedBooks;
  }

  Future<void> _showBorrowForm(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 4,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 223, 221, 221),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Số ngày mượn:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 30),
                      InkWell(
                        onTap: () {
                          if (selectedDays > 1) {
                            setState(() {
                              selectedDays--;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            CupertinoIcons.minus,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedDays.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedDays++;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            CupertinoIcons.plus,
                            size: 18,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Số lượng:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 30),
                      DropdownButton<int>(
                        value: selectedQuantity,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedQuantity = newValue;
                            });
                          }
                        },
                        items: List.generate(
                          5,
                              (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text((index + 1).toString()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      // Thực hiện logic mượn sách khi nhấn vào nút "Mượn ngay"
                      final borrowedBook = BorrowedBook(
                        id: BookDetailsScreen.uuid.v4(),
                        title: widget.entry.title!.t!,
                        author: widget.entry.author!.name!.t!,
                        imageUrl: '', // Add image URL if necessary
                      );
                      final success = await borrowBookFromApi(borrowedBook);
                      if (success) {
                        addBorrowedBook(borrowedBook);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mượn sách thành công!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context); // Đóng bottom sheet
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Không thể mượn sách. Vui lòng thử lại sau.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD725A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Mượn ngay',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> borrowBookFromApi(BorrowedBook borrowedBook) async {
    final url = Uri.parse('http://localhost:9000/api/v1/borrow-service/borrow');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'idBook': borrowedBook.id,
          'username': 'example_user',
          'numberDayBorrow': selectedDays,
          'quantity': selectedQuantity,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Borrow successful
        return true;
      } else {
        // Borrow failed
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        throw Exception('Borrow failed: $error');
      }
    } catch (e) {
      // Error occurred
      print('Error: $e');
      throw Exception('Failed to borrow book: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final autoRouteTopRoute = context.watchRouter.currentChild;
    final canPop = context.router.canPop();

    return Scaffold(
      appBar: AppBar(
        leading: !canPop && autoRouteTopRoute?.name == 'BookDetailsRoute'
            ? CloseButton(
          onPressed: () {
            Navigator.pop(context);
          },
        )
            : null,
        actions: <Widget>[
          IconButton(
            onPressed: () => _share(),
            icon: const Icon(Feather.share),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          const SizedBox(height: 10.0),
          _BookDescriptionSection(
            entry: widget.entry,
            authorTag: widget.authorTag,
            imgTag: widget.imgTag,
            titleTag: widget.titleTag,
            onPressed: () => _showBorrowForm(context),
          ),
          const SizedBox(height: 30.0),
          const _SectionTitle(title: 'Book Description'),
          const _Divider(),
          const SizedBox(height: 10.0),
          DescriptionTextWidget(text: '${widget.entry.summary!.t}'),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }

  void _share() {
    Share.share(
      '${widget.entry.title!.t} by ${widget.entry.author!.name!.t}'
          'Read/Download ${widget.entry.title!.t} from ${widget.entry.link![3].href}.',
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(color: Theme.of(context).textTheme.bodyText2!.color);
  }
}

class _BookDescriptionSection extends StatelessWidget {
  final Entry entry;
  final String imgTag;
  final String titleTag;
  final String authorTag;
  final VoidCallback onPressed;

  const _BookDescriptionSection({
    required this.entry,
    required this.imgTag,
    required this.titleTag,
    required this.authorTag,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: imgTag,
              child: CachedNetworkImage(
                imageUrl: '${entry.link![1].href}',
                placeholder: (context, url) => const SizedBox(
                  height: 200.0,
                  width: 130.0,
                  child: LoadingWidget(),
                ),
                errorWidget: (context, url, error) => const Icon(Feather.x),
                fit: BoxFit.cover,
                height: 200.0,
                width: 130.0,
              ),
            ),
            const SizedBox(width: 20.0),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 5.0),
                  Hero(
                    tag: titleTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        entry.title!.t!.replaceAll(r'\', ''),
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Hero(
                    tag: authorTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        '${entry.author!.name!.t}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  _CategoryChips(entry: entry),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: _BorrowButton(entry: entry, onPressed: onPressed),
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final Entry entry;

  const _CategoryChips({required this.entry});

  @override
  Widget build(BuildContext context) {
    if (entry.category == null) {
      return const SizedBox.shrink();
    } else {
      return Wrap(
        children: [
          ...entry.category!.map((category) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7.0,
                    vertical: 5,
                  ),
                  child: Text(
                    '${category.label}',
                    style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      );
    }
  }
}

class _BorrowButton extends StatelessWidget {
  final Entry entry;
  final VoidCallback onPressed;

  const _BorrowButton({required this.entry, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      child: Text(
        'Mượn sách'.toUpperCase(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: context.theme.colorScheme.secondary,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
