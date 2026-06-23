import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String KEY_STATE = 'home_state';
  static const String KEY_DISTRICT = 'home_district';
  static const String KEY_SYNC_DATE = 'last_sync_date';

  Future<void> saveLocation(String state, String district) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_STATE, state);
    await prefs.setString(KEY_DISTRICT, district);
  }

  Future<Map<String, String?>> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'state': prefs.getString(KEY_STATE),
      'district': prefs.getString(KEY_DISTRICT),
    };
  }

  // New: Store the sync date
  Future<void> saveLastSyncDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_SYNC_DATE, date);
  }

  Future<String?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_SYNC_DATE);
  }
}