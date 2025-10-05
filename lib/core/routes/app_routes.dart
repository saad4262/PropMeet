import 'package:propmeet/presentation/views/signup_auth/phone_signup.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const onBoarding = '/onBoarding';
  static const signUp = '/signUp';
  static const login = '/login';
  static const login2 = '/login2';

  //user side view

  static const bottomBarView = '/bottomBarView';
  static const home = '/home';
  static const chatView = '/chatView';
  static const topAgentView = '/topAgentView';
  static const favouriteView = '/favouriteView';
  static const userProfileView = '/userProfileView';
  static const phoneSignup = '/phoneSignup';
  static const setupProfile = '/setupProfile';
  static const editUserProfile='/editUserProfile';
  static const setupAgent = '/setupAgent';

  static const agentBottomBarView='/agentBottomBarView';
  static const agentSubscriptionPlan='/agentSubscriptionPlan';
  //just for logout
  static const filterPage='/filterPage';
  static const agentEditProfileView='/agentEditProfileView';
  static const notificationScreenUser='/notificationScreenUser';
  static const notificationScreenAgent='/notificationScreenAgent';

}
