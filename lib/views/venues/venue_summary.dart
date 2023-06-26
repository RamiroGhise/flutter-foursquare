import 'package:flutter/material.dart';
import 'package:venues/crud/venue_database_service.dart';
import 'package:venues/services/location/venue.dart';

class VenueSummary extends StatelessWidget {
  final Venue venue;

  const VenueSummary({Key? key, required this.venue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  venue.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${venue.rating.toString()} / 10'),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16.0,
                    ),
                    Text('(${venue.stats.totalRatings} reviews)')
                  ],
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    final dbService = VenuesDatabaseService();
                    dbService.createVenue(venueId: venue.venueId);
                  },
                  icon: const Icon(
                    Icons.bookmark_outline_outlined,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text('${venue.categories.first.name} | ${venue.distanceToVenue} m'),
      ],
    );
  }
}
