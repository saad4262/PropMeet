import 'package:get/get.dart';

class UserProfileViewController extends GetxController{

  final int totalComponents = 6;

  var completedComponents = 5.obs;

  var lookingFor = "Rent".obs;
  var propertyType = "Apartment".obs;
  var location = "Jakarta, Indonesia".obs;

  final lookingForOptions = ["Rent", "Buy", "Sell"];
  final propertyTypeOptions = ["Apartment", "House", "Villa"];
  final locationOptions = ["Jakarta, Indonesia", "Lahore, Pakistan", "Dubai, UAE"];

  void updateLookingFor(String value) => lookingFor.value = value;
  void updatePropertyType(String value) => propertyType.value = value;
  void updateLocation(String value) => location.value = value;
  }

