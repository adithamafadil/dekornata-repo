import 'package:auto_route/auto_route.dart';
import 'package:dekornata_test/presentations/screens/screens.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    AutoRoute(
      page: MainRootScreen,
      path: '/',
      children: [
        AutoRoute(
          name: 'HomeScreenRouter',
          page: EmptyRouterPage,
          path: 'home',
          children: [
            AutoRoute(
              name: 'HomeScreenRoute',
              page: HomeScreen,
              path: '',
            ),
            AutoRoute(
              name: 'DetailScreenRoute',
              page: DetailScreen,
              path: 'detail',
            ),
          ],
        ),
        AutoRoute(
          name: 'CategoryScreenRouter',
          page: EmptyRouterPage,
          path: 'category',
          children: [
            AutoRoute(
              name: 'CategoryScreenRoute',
              page: CategoryScreen,
              path: '',
            ),
          ],
        ),
      ],
    ),
    AutoRoute(
      name: 'CartScreenRouter',
      page: EmptyRouterPage,
      path: 'cart',
      children: [
        AutoRoute(
          name: 'CartScreenRoute',
          page: CartScreen,
          path: '',
        ),
        AutoRoute(
          name: 'CheckoutScreenRoute',
          page: CheckoutScreen,
          path: 'checkoutRoute',
        ),
        AutoRoute(
          name: 'ConfirmationScreenRoute',
          page: ConfirmationScreen,
          path: 'confirmationRoute',
        ),
      ],
    ),
  ],
)
class $DekornataTestRouter {}
