import 'package:venues/services/location/location_service_constants.dart';
import 'package:venues/utilities/date_and_time.dart';

class Venue {
  final String venueId;
  final String name;
  final int distanceToVenue;
  final List<Category> categories;
  final List<Photo> photos;
  final Stats stats;
  final double rating;
  final Location location;
  final String? website;
  final OpenHours? hours;

  Venue({
    required this.venueId,
    required this.name,
    required this.distanceToVenue,
    required this.categories,
    required this.photos,
    required this.stats,
    required this.rating,
    required this.location,
    this.website,
    this.hours,
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
        stats = Stats.fromFoursquare(data[venueStatsFieldName] ?? {}),
        rating = data[venueRatingFieldName] ?? 0.0,
        location = Location.fromFoursquare(data[venueLocationFieldName] ?? {}),
        website = data[venueWebsiteFieldName],
        hours = OpenHours.fromFoursquare(data[venueHoursFieldName]);

  List<String> get photoUrls {
    final List<String> list = [];
    for (final photo in photos) {
      final url = '${photo.prefix}original${photo.suffix}';
      list.add(url);
    }
    return list;
  }

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
        suffix = data[photoSuffixFieldName],
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

class Location {
  final String? address;
  final String? locality;
  final String? dma;
  final String? region;
  final String? postcode;
  final String? country;
  final String? adminRegion;
  final String? postTown;
  final String? poBox;
  final String? crossStreet;
  final String? formattedAddress;
  final String? censusBlock;

  Location({
    this.address,
    this.locality,
    this.dma,
    this.region,
    this.postcode,
    this.country,
    this.adminRegion,
    this.postTown,
    this.poBox,
    this.crossStreet,
    this.formattedAddress,
    this.censusBlock,
  });

  Location.fromFoursquare(Map<String, dynamic> data)
      : address = data[locationAddressFieldName],
        locality = data[locationLocalityFieldName],
        dma = data[locationDmaFieldName],
        region = data[locationRegionFieldName],
        postcode = data[locationPostcodeFieldName],
        country = data[locationCountryFieldName],
        adminRegion = data[locationAdminRegionFieldName],
        postTown = data[locationPostTownFieldName],
        poBox = data[locationPoBoxFieldName],
        crossStreet = data[locationCrossStreetFieldName],
        formattedAddress = data[locationFormattedAddressFieldName],
        censusBlock = data[locationCensusBlockFieldName];

  @override
  String toString() {
    return 'Location, address: $address';
  }
}

class OpenHours {
  final String? display;
  final bool? isLocalHoliday;
  final bool? openNow;
  final List<DailySchedule?>? schedule;

  OpenHours({
    this.display,
    this.isLocalHoliday,
    this.openNow,
    this.schedule,
  });

  OpenHours.fromFoursquare(Map<String, dynamic> data)
      : display = data[openHoursDisplayFieldName],
        isLocalHoliday = data[openHoursIsHolidayFieldName],
        openNow = data[openHoursOpenNowFieldName],
        schedule = ((data[openHoursDailyScheduleFieldName] ?? []) as List)
            .map((dailySchedule) => DailySchedule.fromFoursquare(dailySchedule))
            .toList();

  @override
  String toString() {
    return 'OpenHours, display: $display, isLocalHoliday: $isLocalHoliday, openNow: $openNow, schedule: $schedule';
  }
}

class DailySchedule {
  final String? open;
  final String? close;
  final int? dayNumber;

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  DailySchedule.fromFoursquare(Map<String, dynamic> data)
      : open = formatFoursquareOpenHours(data[dailyScheduleOpenFieldName]),
        close = formatFoursquareOpenHours(data[dailyScheduleCloseFieldName]),
        dayNumber = data[dailyScheduleDayNumberFieldName];

  String? get day {
    final dayNo = dayNumber;
    if (dayNo != null) {
      return _weekdays[dayNo - 1];
    }

    return null;
  }

  @override
  String toString() {
    return 'DailySchedule, day: $day, open: $open, close: $close';
  }
}
