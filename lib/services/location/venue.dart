import 'package:venues/services/location/location_service_constants.dart';

class Venue {
  final String venueId;
  final String name;
  final int distanceToVenue;
  final List<Category> categories;

  Venue({
    required this.venueId,
    required this.name,
    required this.distanceToVenue,
    required this.categories,
  });

  Venue.fromFoursquare(Map<String, dynamic> data)
      : venueId = data[venueIdFieldName],
        name = data[venueNameFieldName],
        distanceToVenue = data[distanceToVenueFieldName] as int,
        categories = (data[venueCategoryFieldName] as List)
            .map((data) => Category.fromFoursquare(data))
            .toList();

  @override
  String toString() {
    return 'Venue, venueId = $venueId, name = $name, distance = $distanceToVenue';
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  Category.fromFoursquare(Map<String, dynamic> data)
      : id = data[categoryIdFieldName],
        name = data[categoryNameFieldName];

  @override
  String toString() {
    return 'Category, id = $id, name = $name';
  }
}
