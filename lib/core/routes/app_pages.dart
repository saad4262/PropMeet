import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:propmeet/core/bindings/auth_binding.dart';
import 'package:propmeet/core/bindings/onBarding_binding.dart';
import 'package:propmeet/core/bindings/splash_bindings.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/presentation/views/home.dart';
import 'package:propmeet/presentation/views/login_auth/login_screen2.dart';
import 'package:propmeet/presentation/views/login_auth/login_screen.dart';
import 'package:propmeet/presentation/views/onboarding_screen.dart';
import 'package:propmeet/presentation/views/signup_auth/signup_screen.dart';
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
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: AuthBinding(),
    ),
      GetPage(
      name: AppRoutes.login2,
      page: () => LoginView2(),
      binding: AuthBinding(),
    ),
  ];
}
