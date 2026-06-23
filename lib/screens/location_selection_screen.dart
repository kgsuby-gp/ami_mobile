import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../helpers/database_helper.dart';

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? _selectedState;
  String? _selectedDistrict;
  List<String> _states = [];
  List<String> _districts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableStates();
  }

  Future<void> _loadAvailableStates() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('SELECT DISTINCT state FROM price_records');
    setState(() {
      _states = results.map((row) => row['state'] as String).toList();
      _isLoading = false;
    });
  }

  Future<void> _loadDistricts(String state) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        'SELECT DISTINCT district FROM price_records WHERE state = ?', [state]);
    setState(() {
      _districts = results.map((row) => row['district'] as String).toList();
      _selectedDistrict = null; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Location")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Select State"),
                  value: _selectedState,
                  items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) {
                    setState(() => _selectedState = val);
                    _loadDistricts(val!);
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Select District"),
                  value: _selectedDistrict,
                  items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (val) => setState(() => _selectedDistrict = val),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (_selectedState != null && _selectedDistrict != null) 
                      ? () async {
                          await SettingsService().saveLocation(_selectedState!, _selectedDistrict!);
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        }
                      : null,
                  child: const Text("Save & Continue"),
                )
              ],
            ),
          ),
    );
  }
}