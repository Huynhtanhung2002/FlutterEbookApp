import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenSmall extends ConsumerStatefulWidget {
  const HomeScreenSmall({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenSmall> createState() => _HomeScreenSmallState();
}

class _HomeScreenSmallState extends ConsumerState<HomeScreenSmall> {
  void loadData() {
    ref.read(homeFeedNotifierProvider.notifier).fetch();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(homeFeedNotifierProvider).maybeWhen(
        orElse: () => loadData(),
        data: (_) => null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeDataState = ref.watch(homeFeedNotifierProvider);
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 600.0
          ? AppBar(
        centerTitle: true,
        title: const Text(
          appName,
          style: TextStyle(fontSize: 20.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final popularFeed = homeDataState.value?.popularFeed;
              final entries = popularFeed?.feed?.entry ?? [];
              showSearch(
                context: context,
                delegate: BookSearchDelegate(books: entries),
              );
            },
          ),
        ],
      )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: homeDataState.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          data: (feeds) {
            if (feeds != null) {
              final popular = feeds.popularFeed;
              final recent = feeds.recentFeed;
              return RefreshIndicator(
                onRefresh: () async => loadData(),
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 30.0),
                    FeaturedSection(popular: popular),
                    const SizedBox(height: 20.0),
                    const _SectionTitle(title: 'Danh mục'),
                    const SizedBox(height: 10.0),
                    _GenreSection(popular: popular),
                    const SizedBox(height: 20.0),
                    const _SectionTitle(title: 'Thêm gần đây'),
                    const SizedBox(height: 20.0),
                    _NewSection(recent: recent),
                  ],
                ),
              );
            } else {
              // Xử lý trường hợp khi dữ liệu là null
              return const SizedBox.shrink();
            }
          },
          error: (_, __) {
            return MyErrorWidget(
              refreshCallBack: () => loadData(),
            );
          },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedSection extends StatelessWidget {
  final CategoryFeed? popular;

  const FeaturedSection({Key? key, required this.popular}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: popular?.feed?.entry?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Entry entry = popular!.feed!.entry![index];
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: BookCard(
                img: entry.link![1].href!,
                entry: entry,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GenreSection extends StatelessWidget {
  final CategoryFeed? popular;

  const _GenreSection({required this.popular});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: popular?.feed?.link?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Link link = popular!.feed!.link![index];
            if (index < 10) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  onTap: () {
                    final route = GenreRoute(
                      title: '${link.title}',
                      url: link.href!,
                    );
                    if (MediaQuery.of(context).size.width > 1200.0) {
                      context.router.replace(route);
                    } else {
                      context.router.push(route);
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${link.title}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NewSection extends StatelessWidget {
  final CategoryFeed? recent;

  const _NewSection({required this.recent});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent?.feed?.entry?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final Entry entry = recent!.feed!.entry![index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: BookListItem(entry: entry),
        );
      },
    );
  }
}

class BookSearchDelegate extends SearchDelegate<Entry> {
  final List<Entry> books;

  BookSearchDelegate({required this.books});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // Tạo một thể hiện Entry trống và truyền vào hàm close
        close(context, Entry());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Entry> searchResults = books.where((book) {
      final title = book.title?.t?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();
    return _buildSearchResults(context, searchResults);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Entry> searchResults = books.where((book) {
      final title = book.title?.t?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();
    return _buildSearchResults(context, searchResults);
  }

  Widget _buildSearchResults(BuildContext context, List<Entry> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        final Entry book = searchResults[index];
        return GestureDetector(
          onTap: () {
            final entry = searchResults[index];
            final imgTag = 'book_image_${entry.id}'; // Generate a unique tag for image
            final titleTag = 'book_title_${entry.id}'; // Generate a unique tag for title
            final authorTag = 'book_author_${entry.id}'; // Generate a unique tag for author
            final route = BookDetailsRoute(
              entry: entry,
              imgTag: imgTag,
              titleTag: titleTag,
              authorTag: authorTag,
            );
            context.router.push(route);
          },
          child: ListTile(
            title: Text(book.title?.t ?? ''),
          ),
        );
      },
    );
  }
}
