import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env loaded");
  } catch (e) {
    print("❌ .env loading failed: $e");
  }

  try {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_KEY'];

    if (supabaseUrl == null || supabaseKey == null) {
      throw Exception("Missing Supabase credentials in .env");
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
    print("✅ Supabase initialized");
  } catch (e) {
    print("❌ Supabase init failed: $e");
  }

  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(child: Text('Zeyquorra is alive ✅')),
    ),
  ));
}
