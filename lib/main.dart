import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env loaded successfully");
  } catch (e) {
    print("❌ .env failed: $e");
  }

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("Zeyquorra - Step 1")),
      body: Center(child: Text("Dotenv loaded")),
    ),
  ));
}
