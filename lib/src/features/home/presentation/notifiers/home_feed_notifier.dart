import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_feed_notifier.g.dart';

typedef HomeFeedData = ({CategoryFeed popularFeed, CategoryFeed recentFeed});

@riverpod
class HomeFeedNotifier extends _$HomeFeedNotifier {
  HomeFeedNotifier() : super();

  @override
  Future<HomeFeedData> build() async { // ghi đè để tạo và trả về dữ liệu cho provider
    state = const AsyncValue.loading(); // Đặt trạng thái của provider thành loading
    return _fetch(); // lấy dữ liệu
  }

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => _fetch()); // cập nhật trạng thái
  }

  Future<HomeFeedData> _fetch() async { // lấy dữ liệu từ HomeRepository
    final HomeRepository homeRepository = ref.read(homeRepositoryProvider);
    // Lấy dữ liệu về popularFeed và recentFeed từ HomeRepository
    final popularFeedSuccessOrFailure =
        await homeRepository.getPopularHomeFeed();
    final recentFeedSuccessOrFailure = await homeRepository.getRecentHomeFeed();
    final popularFeed = popularFeedSuccessOrFailure.feed; // Dữ liệu về popularFeed
    final recentFeed = recentFeedSuccessOrFailure.feed; // Dữ liệu về recentFeed
    // Nếu không có dữ liệu, ném ra một ngoại lệ với mô tả lỗi tương ứng
    if (popularFeed == null) {
      throw popularFeedSuccessOrFailure.failure!.description;
    }

    if (recentFeed == null) {
      throw recentFeedSuccessOrFailure.failure!.description;
    }
    // Trả về dữ liệu về popularFeed và recentFeed dưới dạng một cặp giá trị HomeFeedData
    return (popularFeed: popularFeed, recentFeed: recentFeed);
  }
}
