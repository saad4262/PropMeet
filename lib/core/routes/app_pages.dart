

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:propmeet/core/bindings/home_bindings.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/presentation/views/home.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
