import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env loaded successfully");
  } catch (e) {
    print("❌ .env failed: $e");
  }

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  runApp(const ZeyquorraApp());
}

class ZeyquorraApp extends StatelessWidget {
  const ZeyquorraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeyquorra',
      home: SupabaseTestScreen(),
    );
  }
}

class SupabaseTestScreen extends StatelessWidget {
  const SupabaseTestScreen({super.key});

  Future<void> runTest(BuildContext context) async {
    try {
      final res = await Supabase.instance.client.from('messages').insert({
        'username': 'test_user',
        'question': 'Can I be a lawyer?',
        'response': 'Law requires strong language and analytical skills.'
      });
      print("✅ Insert successful: $res");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Insert successful")),
      );
    } catch (e) {
      print("❌ Insert failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Insert failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Zeyquorra - Supabase Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => runTest(context),
          child: Text("Run Supabase Insert"),
        ),
      ),
    );
  }
}
