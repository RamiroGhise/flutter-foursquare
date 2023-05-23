import 'package:venues/services/location/location_service_constants.dart';

class Venue {
  final String venueId;
  final String name;
  final int distanceToVenue;
  final List<Category> categories;
  final List<Photo> photos;
  final Stats stats;
  final double rating;

  Venue({
    required this.venueId,
    required this.name,
    required this.distanceToVenue,
    required this.categories,
    required this.photos,
    required this.stats,
    required this.rating,
  });

  Venue.fromFoursquare(Map<String, dynamic> data)
      : venueId = data[venueIdFieldName],
        name = data[venueNameFieldName],
        distanceToVenue = data[distanceToVenueFieldName] as int,
        categories = (data[venueCategoryFieldName] as List)
            .map((data) => Category.fromFoursquare(data))
            .toList(),
        photos = (data[venuePhotosFieldName] as List)
            .map((photo) => Photo.fromFoursquare(photo))
            .toList(),
        stats = Stats.fromFoursquare(data[venueStatsFieldName]),
        rating = data[venueRatingFieldName];

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

class Photo {
  final String id;
  final String prefix;
  final String suffix;
  final int width;
  final int height;

  Photo({
    required this.id,
    required this.prefix,
    required this.suffix,
    required this.width,
    required this.height,
  });

  Photo.fromFoursquare(Map<String, dynamic> data)
      : id = data[photoIdFieldName],
        prefix = data[photoPrefixFieldName],
        suffix = data[photoPrefixFieldName],
        width = data[photoWidthFieldName],
        height = data[photoHeightFieldName];

  @override
  String toString() {
    return 'Photo, id: $id, width: $width, height: $height';
  }
}

class Stats {
  final int totalPhotos;
  final int totalRatings;
  final int totalTips;

  Stats({
    required this.totalPhotos,
    required this.totalRatings,
    required this.totalTips,
  });

  Stats.fromFoursquare(Map<String, dynamic> data)
      : totalPhotos = data[statsTotalPhotosFieldName] ?? 0,
        totalRatings = data[statsTotalRatingsFieldName] ?? 0,
        totalTips = data[statsTotalTipsFieldName] ?? 0;

  @override
  String toString() {
    return 'Stats, totalPhotos: $totalPhotos, totalRatings: $totalRatings, totalTips: $totalTips';
  }
}
