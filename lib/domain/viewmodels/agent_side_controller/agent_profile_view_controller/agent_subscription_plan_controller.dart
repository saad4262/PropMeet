import 'package:get/get.dart';

enum SubscriptionPlan { gold, silver }

class AgentSubscriptionPlanController extends GetxController {

  final Rx<SubscriptionPlan> selectedPlan = SubscriptionPlan.gold.obs;

  final RxBool isSubscribed = false.obs;

  void selectPlan(SubscriptionPlan plan) {
    selectedPlan.value = plan;
  }

  void subscribeToGold() {
    selectedPlan.value = SubscriptionPlan.gold;
    isSubscribed.value = true;
    print("User subscribed to GOLD plan ");
  }

  void subscribeToSilver() {
    selectedPlan.value = SubscriptionPlan.silver;
    isSubscribed.value = true;
    print("User subscribed to SILVER plan ");
  }

  void cancelSubscription() {
    isSubscribed.value = false;
    print("User cancelled subscription ");
  }
}
