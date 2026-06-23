import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class SearchPriceScreen extends StatefulWidget {
  const SearchPriceScreen({super.key});

  @override
  State<SearchPriceScreen> createState() => _SearchPriceScreenState();
}

class _SearchPriceScreenState extends State<SearchPriceScreen> {
  String? _selectedState;
  String? _selectedDistrict;
  List<String> _states = [];
  List<String> _districts = [];
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  // ... _loadStates and _loadDistricts remain the same ...
  Future<void> _loadStates() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.rawQuery('SELECT DISTINCT state FROM price_records');
    if (mounted) setState(() => _states = data.map((e) => e['state'] as String).toList());
  }

  Future<void> _loadDistricts(String state) async {
    setState(() => _isLoading = true);
    final db = await DatabaseHelper.instance.database;
    final data = await db.rawQuery('SELECT DISTINCT district FROM price_records WHERE state = ?', [state]);
    if (mounted) setState(() { _districts = data.map((e) => e['district'] as String).toList(); _selectedDistrict = null; _isLoading = false; });
  }

  Future<void> _performSearch() async {
    if (_selectedState == null || _selectedDistrict == null) return;
    setState(() => _isLoading = true);
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('price_records', where: 'state = ? AND district = ?', whereArgs: [_selectedState, _selectedDistrict]);
    if (mounted) setState(() { _results = data; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12));

    return Scaffold(
      appBar: AppBar(title: const Text("Search Other Markets")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: inputDecoration.copyWith(labelText: "Select State"),
              value: _selectedState,
              items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) { setState(() => _selectedState = val); _loadDistricts(val!); },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              decoration: inputDecoration.copyWith(labelText: "Select District"),
              value: _selectedDistrict,
              items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (val) => setState(() => _selectedDistrict = val),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _performSearch,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                child: const Text("Search Prices", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (ctx, i) => Card(
                child: ListTile(
                  title: Text(_results[i]['commodity']),
                  subtitle: Text(_results[i]['market']), // Added Market display
                  trailing: Text("₹${_results[i]['modalPrice']}"),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}