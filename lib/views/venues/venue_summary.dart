import 'package:flutter/material.dart';
import 'package:venues/crud/venue_database_service.dart';
import 'package:venues/services/location/venue.dart';

class VenueSummary extends StatefulWidget {
  final Venue venue;

  const VenueSummary({
    Key? key,
    required this.venue,
  }) : super(key: key);

  @override
  State<VenueSummary> createState() => _VenueSummaryState();
}

class _VenueSummaryState extends State<VenueSummary> {

  @override


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
                  widget.venue.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${widget.venue.rating.toString()} / 10'),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16.0,
                    ),
                    Text('(${widget.venue.stats.totalRatings} reviews)')
                  ],
                ),
              ],
            ),
            Column(
              children: [
                FutureBuilder<bool>(
                  initialData: false,
                  future: VenuesDatabaseService()
                      .isVenueBookmarked(venueId: widget.venue.venueId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        final isBookmarked = snapshot.data!;
                        return IconButton(
                          onPressed: () async {
                            // todo trigger add/remove bookmark action
                            if (isBookmarked) {
                              await VenuesDatabaseService()
                                  .deleteVenue(venueId: widget.venue.venueId);
                              setState(() {});
                            } else {
                              await VenuesDatabaseService()
                                  .createVenue(venueId: widget.venue.venueId);
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark_outlined
                                : Icons.bookmark_outline_outlined,
                            color: Colors.blue,
                          ),
                        );
                      } else {
                        return const SizedBox(
                          height: 48.0,
                          width: 48.0,
                          child: SizedBox(
                              height: 24.0, child: CircularProgressIndicator()),
                        );
                      }
                    } else {
                      return IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.bookmark_outline_outlined,
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        Text(
            '${widget.venue.categories.first.name} | ${widget.venue.distanceToVenue} m'),
      ],
    );
  }
}
