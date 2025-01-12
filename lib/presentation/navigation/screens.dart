enum Screens {
  home,
  venueDetails,
  favoriteVenues;

  String get name {
    switch(this) {
      case Screens.home:
        return '/';
      case Screens.venueDetails:
        return 'venueDetails';
      case Screens.favoriteVenues:
        return 'favoriteVenues';
    }
  }

  String get path {
    switch(this) {
      case Screens.home:
        return '/';
      case Screens.venueDetails:
        return 'venueDetails';
      case Screens.favoriteVenues:
        return 'favoriteVenues';
    }
  }
}