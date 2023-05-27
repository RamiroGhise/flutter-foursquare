import 'package:flutter/material.dart';
import 'package:venues/services/location/venue.dart';
import 'package:venues/utilities/widgets/image_carousel.dart';
import 'package:venues/views/venues/venue_summary.dart';

class VenueDetailsView extends StatelessWidget {
  const VenueDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final venue = ModalRoute.of(context)!.settings.arguments as Venue;
    final schedule = venue.hours?.schedule;

    return Scaffold(
      appBar: AppBar(
        title: const Text('details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VenueSummary(venue: venue),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                child: ImageCarousel(
                  imageUrls: venue.photoUrls,
                  height: 300.0,
                  width: 200.0,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(
                  venue.location.formattedAddress ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (venue.website != null)
                ListTile(
                  leading: const Icon(Icons.public),
                  title: Text(
                    venue.website ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (venue.hours != null && schedule != null)
                ExpansionTile(
                  leading: const Icon(Icons.watch_later_outlined),
                  title: Text(
                    venue.hours?.display ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: generateTimeListTiles(schedule).toList()
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Iterable<Widget> generateTimeListTiles(List<DailySchedule?> schedule) {
  return schedule.map((dailySchedule) {
    final day = dailySchedule?.day;
    final open = dailySchedule?.open;
    final close = dailySchedule?.close;
    if (day != null && open != null && close != null) {
      return ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(day),
              Text('$open - $close'),
            ],
          ),
        ),
      );
    } else {
      // if information for a day is missing
      return Container();
    }
  });
}
