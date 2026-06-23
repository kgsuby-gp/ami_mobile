import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../helpers/database_helper.dart';
import 'search_price_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _district;
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final loc = await SettingsService().getLocation();
    setState(() => _district = loc['district']);

    if (loc['state'] != null && loc['district'] != null) {
      final db = await DatabaseHelper.instance.database;
      final data = await db.query(
        'price_records',
        where: 'state = ? AND district = ?',
        whereArgs: [loc['state'], loc['district']],
      );
      if (mounted) setState(() { _records = data; _isLoading = false; });
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard: ${_district ?? 'Unknown'}"),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPriceScreen()))),
          IconButton(icon: const Icon(Icons.location_on), onPressed: () => Navigator.pushNamed(context, '/location-selection'))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const Center(child: Text("No data found for this location."))
              : ListView.builder(
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final r = _records[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.grass, color: Colors.white)),
                        title: Text(r['commodity'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(r['market'] ?? 'N/A'), // Added Market display
                        trailing: Text("₹${r['modalPrice']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                      ),
                    );
                  },
                ),
    );
  }
}