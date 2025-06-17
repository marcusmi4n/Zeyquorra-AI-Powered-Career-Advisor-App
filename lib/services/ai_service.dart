import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> getCareerAdvice(String question) async {
  final apiKey = dotenv.env['OPENROUTER_API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    return "API key is missing. Please check your configuration.";
  }

  final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final body = json.encode({
    "model": "deepseek/deepseek-r1-0528:free", // Fast + solid
    "messages": [
      {
        "role": "system",
        "content": "You are Zeyquorra, a smart, friendly AI career advisor for Ugandan secondary students. Give short, practical answers unless more detail is needed."
      },
      {
        "role": "user",
        "content": question
      }
    ]
  });

  try {
    final response = await http
        .post(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      return "⚠️ Zeyquorra couldn't respond right now. Try again shortly.";
    }
  } catch (e) {
    return "❌ Connection timeout or network error. Please check your internet and try again.";
  }
}
