import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ExploreScreenSmall extends ConsumerStatefulWidget {
  const ExploreScreenSmall({super.key});

  @override
  ConsumerState<ExploreScreenSmall> createState() => _ExploreScreenSmallState(); // Tạo và trả về một trạng thái của widget.
}

class _ExploreScreenSmallState extends ConsumerState<ExploreScreenSmall>
    with AutomaticKeepAliveClientMixin {
  void loadData() { // gọi để tải dữ liệu từ provider.
    ref.read(homeFeedNotifierProvider.notifier).fetch(); // Gọi fetch từ homeFeedNotifierProvider để tải dữ liệu.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Đọc trạng thái của homeFeedNotifierProvider.
    final homeDataState = ref.watch(homeFeedNotifierProvider);
    return Scaffold(
      appBar: context.isSmallScreen
          ? AppBar(centerTitle: true, title: const Text('Khám phá'))
          : null,
      body: homeDataState.maybeWhen( // Xử lý dữ liệu trả về từ homeFeedNotifierProvider.
        orElse: () => const SizedBox.shrink(), // Trường hợp mặc định, trả về widget rỗng.
        loading: () => const LoadingWidget(), // Trường hợp đang tải dữ liệu, hiển thị LoadingWidget
        data: (feeds) { // Trường hợp dữ liệu đã tải thành công..
          final popular = feeds.popularFeed;  // Lấy dữ liệu popularFeed từ feeds.
          return ListView.builder(
            itemCount: popular.feed?.link?.length ?? 0, // Số lượng phần tử trong danh sách.
            itemBuilder: (BuildContext context, int index) { // Xây dựng mỗi phần tử trong danh sách.
              final Link link = popular.feed!.link![index];  // Lấy dữ liệu từng phần tử.
              if (!context.isSmallScreen && index == 0) { // Kiểm tra nếu không phải màn hình nhỏ và index là 0.
                return const SizedBox(height: 30.0);
              }

              if (index < 10) {
                return const SizedBox(); // Kiểm tra nếu index nhỏ hơn 10, trả về rỗng
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _SectionBookList(link: link), // Trả về _SectionBookList với dữ liệu link tương ứng.
              );
            },
          );
        },
        error: (_, __) {
          return MyErrorWidget(
            refreshCallBack: () => loadData(),  // Gọi lại hàm loadData khi cần refresh dữ liệu.
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // giữ trạng thái của widget khi chuyển qua các tab.
}

class _SectionHeader extends StatelessWidget {
  final Link link;
  final bool hideSeeAll;

  const _SectionHeader({required this.link, this.hideSeeAll = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              '${link.title}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!hideSeeAll)
            GestureDetector(
              onTap: () {
                context.router.push(
                  GenreRoute(title: '${link.title}', url: link.href!),
                );
              },
              child: Text(
                'See All',
                style: TextStyle(
                  color: context.theme.colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionBookList extends ConsumerStatefulWidget {
  final Link link;

  const _SectionBookList({required this.link});

  @override
  ConsumerState<_SectionBookList> createState() => _SectionBookListState();
}

class _SectionBookListState extends ConsumerState<_SectionBookList>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> _bookCount = ValueNotifier<int>(0);

  void _fetch() {
    ref.read(genreFeedNotifierProvider(widget.link.href!).notifier).fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _bookCount,
          builder: (context, bookCount, _) {
            return _SectionHeader(
              link: widget.link,
              hideSeeAll: bookCount < 10,
            );
          },
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 200,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: ref
                .watch(genreFeedNotifierProvider(widget.link.href!))
                .maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loading: () => const LoadingWidget(),
                  data: (data) {
                    final books = data.books;
                    if (_bookCount.value == 0) {
                      _bookCount.value = books.length;
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final Entry entry = books[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 10.0,
                          ),
                          child:
                              BookCard(img: entry.link![1].href!, entry: entry),
                        );
                      },
                    );
                  },
                  error: (_, __) {
                    return MyErrorWidget(
                      refreshCallBack: () {
                        _fetch();
                      },
                    );
                  },
                ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
