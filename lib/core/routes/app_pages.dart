import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:propmeet/core/bindings/auth_binding.dart';
import 'package:propmeet/core/bindings/bottom_bar_binding/bottom_bar_binding.dart';
import 'package:propmeet/core/bindings/onBarding_binding.dart';
import 'package:propmeet/core/bindings/splash_bindings.dart';
import 'package:propmeet/core/bindings/user_profile_binding.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/chat_view_controller/chat_view_controller.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/favourites_view_controller/favourite_view_controller.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/home_controller/home_controller.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/top_agent_view_controller/top_agent_view_controller.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/user_profile_view_controller/user_profile_view_controller.dart';
import 'package:propmeet/presentation/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:propmeet/presentation/views/login_auth/login_screen2.dart';
import 'package:propmeet/presentation/views/login_auth/login_screen.dart';
import 'package:propmeet/presentation/views/onboarding_screen.dart';
import 'package:propmeet/presentation/views/signup_auth/phone_signup.dart';
import 'package:propmeet/presentation/views/signup_auth/signup_screen.dart';
import 'package:propmeet/presentation/views/splash_screen.dart';
import 'package:propmeet/presentation/views/user_profile/user_profile1.dart';
import 'package:propmeet/presentation/views/user_side_views/chat_view/chat_view.dart';
import 'package:propmeet/presentation/views/user_side_views/favourites_view/favourites_view.dart';
import 'package:propmeet/presentation/views/user_side_views/top_agents_view/top_agent_view.dart';
import 'package:propmeet/presentation/views/user_side_views/user_profile_view/user_profile_view.dart';

import '../../presentation/views/user_side_views/home_view/home.dart';

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
      name: AppRoutes.login2,
      page: () => LoginView2(),
      binding: AuthBinding(),
    ),

    //user side views routes
    GetPage(
      name: AppRoutes.bottomBarView,
      page: () => BottomBarView(),
      binding: BottomBarBinding(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),

    GetPage(
      name: AppRoutes.chatView,
      page: () => ChatView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChatViewController>(() => ChatViewController());
      }),
    ),

    GetPage(
      name: AppRoutes.topAgentView,
      page: () => TopAgentView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TopAgentViewController>(() => TopAgentViewController());
      }),
    ),

    GetPage(
      name: AppRoutes.favouriteView,
      page: () => FavouritesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<FavouriteViewController>(() => FavouriteViewController());
      }),
    ),

    GetPage(
      name: AppRoutes.userProfileView,
      page: () => UserProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UserProfileViewController>(
          () => UserProfileViewController(),
        );
      }),
    ),

    GetPage(
      name: AppRoutes.phoneSignup,
      page: () => PhoneSignup(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.setupProfile,
      page: () => ProfileSetupScreen(),
      binding: ProfileSetupBinding(),
    ),
  ];
}
