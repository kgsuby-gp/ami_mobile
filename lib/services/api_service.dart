import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../models/price_record.dart';
import '../helpers/database_helper.dart';
import 'settings_service.dart';

class ApiService {
  // Use String.fromEnvironment to inject the URL at build time.
  // Default to the local dev URL if no environment variable is provided.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://ami-service.onrender.com/api/sync',
  );

  Future<void> syncData() async {
    final String today = DateTime.now().toString().split(' ')[0];
    final String? lastSync = await SettingsService().getLastSyncDate();

    if (lastSync == today) {
      print("Data is already up to date for $today. Skipping sync.");
      return;
    }

    final db = await DatabaseHelper.instance.database;
    int page = 0;
    bool hasMore = true;

    try {
      // Clear old data for a fresh sync
      await db.delete('price_records');
      
      while (hasMore) {
        // Use the dynamic baseUrl
        final response = await http.get(Uri.parse('$baseUrl/all-daily-records?page=$page&size=1000'));

        if (response.statusCode == 200) {
          final List<dynamic> records = json.decode(response.body);

          if (records.isEmpty) {
            hasMore = false;
          } else {
            Batch batch = db.batch();
            for (var item in records) {
              PriceRecord record = PriceRecord.fromJson(item);
              
              batch.insert(
                'price_records', 
                record.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
            await batch.commit(noResult: true);
            
            page++;
            if (records.length < 1000) {
              hasMore = false;
            }
          }
        } else {
          print("Sync failed with status code: ${response.statusCode}");
          hasMore = false;
        }
      }
      
      await SettingsService().saveLastSyncDate(today);
      print("Sync completed successfully for $today.");
    } catch (e) {
      print("Sync error: $e");
    }
  }
}
