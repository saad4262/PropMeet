class PlaceSuggestion {
  final String placeId;
  final String description;

  PlaceSuggestion({required this.placeId, required this.description});

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      placeId: json['place_id'],
      description: json['description'],
    );
  }
}

class PlaceDetails {
  final double lat;
  final double lng;
  final String address;
  final String name;

  PlaceDetails({
    required this.lat,
    required this.lng,
    required this.address,
    required this.name,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final result = json['result'];
    return PlaceDetails(
      lat: result['geometry']['location']['lat'],
      lng: result['geometry']['location']['lng'],
      address: result['formatted_address'] ?? "No address available",
      name: result['name'] ?? "No name available",
    );
  }
}
