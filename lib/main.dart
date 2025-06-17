import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
    );
    print("✅ Supabase initialized");
  } catch (e) {
    print("❌ Supabase failed: $e");
  }

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("Zeyquorra - Step 2")),
      body: Center(child: Text("Supabase initialized")),
    ),
  ));
}
