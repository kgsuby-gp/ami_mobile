import 'package:flutter/material.dart';
import 'services/settings_service.dart';
import 'services/api_service.dart';
import 'screens/location_selection_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
        // FIXED: Using CardThemeData explicitly
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
      ),
      home: const InitialLoadingScreen(),
      routes: {
        '/location-selection': (context) => LocationSelectionScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});
  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await ApiService().syncData();
    } catch (e) {
      debugPrint("Sync failed: $e");
    }

    final loc = await SettingsService().getLocation();
    final bool hasLocation = loc['state'] != null && loc['district'] != null;

    if (mounted) {
      Navigator.pushReplacementNamed(context, hasLocation ? '/dashboard' : '/location-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Syncing latest market data..."),
          ],
        ),
      ),
    );
  }
}