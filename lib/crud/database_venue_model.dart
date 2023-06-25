import 'package:flutter/foundation.dart';
import 'package:venues/crud/database_constants.dart';

@immutable
class DatabaseVenue {
  final int id;
  final String venueId;

  const DatabaseVenue({
    required this.id,
    required this.venueId,
  });

  DatabaseVenue.fromRow(Map<String, Object?> map)
      : id = map[venuesTableIdColumn] as int,
        venueId = map[venuesTableRemoteIdColumn] as String;

  @override
  bool operator ==(covariant DatabaseVenue other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DatabaseVenue, id: $id, providerId: $venueId';
  }
}
