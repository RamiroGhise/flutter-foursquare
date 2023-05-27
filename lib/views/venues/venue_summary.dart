import 'package:flutter/material.dart';
import 'package:venues/services/location/venue.dart';

class VenueSummary extends StatelessWidget {
  final Venue venue;

  const VenueSummary({Key? key, required this.venue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          venue.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
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
        Text(
            '${venue.categories.first.name} | ${venue.distanceToVenue} m'),
      ],
    );
  }
}
