import 'package:venues/constants/foursquare.dart' as foursquare;

class AppConfig {
  static const String _developmentMode = 'dev';
  static bool isDeveloperMode = false;
  static String foursquareApiKey = '';

  AppConfig._sharedInstance();

  static final AppConfig _shared = AppConfig._sharedInstance();

  factory AppConfig() {
    return _shared;
  }

  void initConfig() {
    isDeveloperMode = _isDevelopmentMode();
    foursquareApiKey = _getFoursquareApiKey(devKey: isDeveloperMode);
  }

  bool _isDevelopmentMode() {
    String mode = const String.fromEnvironment('env', defaultValue: 'lorem');
    return mode == _developmentMode;
  }

  String _getFoursquareApiKey({required bool devKey}) {
    return devKey
        ? foursquare.devFoursquareApiKey
        : foursquare.foursquareApiKey;
  }
}
