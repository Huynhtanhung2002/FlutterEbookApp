import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:provider/provider.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
// Định nghĩa class AppRouter kế thừa từ _$AppRouter, được sinh ra từ auto_route
class AppRouter extends _$AppRouter {
  @override
  // Override phương thức routes, trả về danh sách các tuyến đường
  List<AutoRoute> get routes {
    return <AutoRoute>[
      // Trả về một danh sách các tuyến đường
      AutoRoute(
        page: SplashRoute.page,// Trang Splash tạm thời
        path: '/', // Đường dẫn của tuyến đường
      ),
      AutoRoute(
        page: LoginRoute.page,
        path: '/login',
      ),

      AutoRoute(
        page: TabsRoute.page,
        path: '/tabs-screen',
        children: <AutoRoute>[
          RedirectRoute(path: '', redirectTo: 'home-tab'),
          CupertinoRoute(
            page: HomeRoute.page,
            path: 'home-tab',
            children: [
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: BookDetailsRoute.page,
                path: 'book-details-nested-tab',
              ),
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: GenreRoute.page,
                path: 'genre-nested-tab',
              ),
            ],
          ),
          CupertinoRoute(
            page: ExploreRoute.page,
            path: 'explore-tab',
            children: [
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: BookDetailsRoute.page,
                path: 'book-details-nested-tab',
              ),
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: GenreRoute.page,
                path: 'genre-nested-tab',
              ),
            ],
          ),
          CupertinoRoute(
            page: SettingsRoute.page,
            path: 'settings-tab',
            children: [
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: BorrowedBooksRoute.page,
                path: 'brrow_book-nested-tab',
              ),
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: FavoritesRoute.page,
                path: 'favorites-nested-tab',
              ),
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: LicensesRoute.page,
                path: 'licenses-nested-tab',
              ),
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: BookDetailsRoute.page,
                path: 'book-details-nested-tab',
              ),
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: LoginRoute.page,
                path: 'login',
              ),
              CustomRoute(
                transitionsBuilder: (_, __, ___, child) => child,
                page: EditProfileRoute.page,
                path: 'edit-profile',
              ),
            ],
          ),
        ],
      ),
      CupertinoRoute(
        page: BookDetailsRoute.page,
        path: '/book-details-tab',
      ),
      CupertinoRoute(
        page: ExploreRoute.page,
        path: '/explore-tab',
      ),
      CupertinoRoute(
        page: GenreRoute.page,
        path: '/genre-tab',
      ),
      CupertinoRoute(
        page: BorrowedBooksRoute.page,
        path: '/brrow_book-tab',
      ),
      CupertinoRoute(
        page: LoginRoute.page,
        path: '/login',
      ),
      CupertinoRoute(
        page: FavoritesRoute.page,
        path: '/favorites-tab',
      ),
      CupertinoRoute(
        page: LicensesRoute.page,
        path: '/licenses-tab',
      ),
      CupertinoRoute(
        page: EditProfileRoute.page,
        path: '/edit-profile',
      ),
    ];

  }

}

// class BlockHomeBackGuard extends AutoRouteGuard {
//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     final isLoggedIn = router.navigatorKey.currentContext!.read<AuthProvider>().isLoggedIn;
//     if (!isLoggedIn) {
//       resolver.next(true);
//     } else {
//       router.pushAndPopUntil(const LoginRoute(), predicate: (_) => false);
//     }
//   }
// }
//
// class AuthGuard extends AutoRouteGuard {
//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     final isLoggedIn = router.navigatorKey.currentContext!.read<AuthProvider>().isLoggedIn;
//     if (!isLoggedIn) {
//       router.pushAndPopUntil(const LoginRoute(), predicate: (_) => false);
//     } else {
//       resolver.next(true);
//     }
//   }
// }







