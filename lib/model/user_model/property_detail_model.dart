
class PropertyDetails {
  final String value;
  final String bathrooms;
  final String bedrooms;
  final String carSpaces;
  final String landSize;

  PropertyDetails({
    required this.value,
    required this.bathrooms,
    required this.bedrooms,
    required this.carSpaces,
    required this.landSize,
  });

  factory PropertyDetails.fromMap(Map<String, dynamic> map) {
    return PropertyDetails(
      value: map['Approx. Property Value']?.toString() ?? '',
      bathrooms: map['Bathrooms']?.toString() ?? '',
      bedrooms: map['Bedrooms']?.toString() ?? '',
      carSpaces: map['Car Spaces']?.toString() ?? '',
      landSize: map['Land Size']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Approx. Property Value': value,
      'Bathrooms': bathrooms,
      'Bedrooms': bedrooms,
      'Car Spaces': carSpaces,
      'Land Size': landSize,
    };
  }
}
