enum Screens {
  splash,
  home,
  venueDetails,
  favoriteVenues;

  String get name {
    switch(this) {
      case Screens.splash:
        return 'splash';
      case Screens.home:
        return 'home';
      case Screens.venueDetails:
        return 'venueDetails';
      case Screens.favoriteVenues:
        return 'favoriteVenues';
    }
  }

  String get path {
    switch(this) {
      case Screens.splash:
        return '/';
      case Screens.home:
        return '/home';
      case Screens.venueDetails:
        return 'venueDetails';
      case Screens.favoriteVenues:
        return '/favoriteVenues';
    }
  }
}