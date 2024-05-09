import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class BookCard extends ConsumerWidget {
  final String img;
  final Entry entry;

  BookCard({
    super.key,
    required this.img,
    required this.entry,
  });

  // Tạo UUID để sử dụng làm thẻ cho Hero widget
  static const uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 120.0,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 4.0,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          onTap: () {
            final bool isHomeTab =
                ref.read(currentTabNotifierProvider).isHomeTab; // Kiểm tra xem tab hiện tại có phải là trang chủ không
            final route = BookDetailsRoute(  // Tạo đối tượng định tuyến để chuyển đến trang chi tiết sách
              entry: entry,
              imgTag: imgTag,
              titleTag: titleTag,
              authorTag: authorTag,
            );

            // Kiểm tra xem thiết bị có phải là màn hình lớn và đang ở tab trang chủ không
            if (context.isLargeScreen && isHomeTab) {
              context.router.replace(route); // Thay thế địa chỉ URL hiện tại bằng địa chỉ URL mới của trang chi tiết
            } else {
              context.router.push(route); // Chuyển đến trang chi tiết sách
            }
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Hero(
              tag: imgTag,
              child: CachedNetworkImage(
                imageUrl: img,
                placeholder: (context, url) => const LoadingWidget(
                  isImage: true,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/place.png',
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
