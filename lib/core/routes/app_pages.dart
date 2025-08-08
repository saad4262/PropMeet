import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:propmeet/core/bindings/onBarding_binding.dart';
import 'package:propmeet/core/bindings/splash_bindings.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/presentation/views/onboarding_screen.dart';
import 'package:propmeet/presentation/views/splash_screen.dart';


class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
     GetPage(
      name: AppRoutes.onBoarding,
      page: () => OnboardingScreen(),
      binding: OnBoardBinding(),
    ),
  ];
}
