import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> getCareerAdvice(String question) async {
  final apiKey = dotenv.env['OPENROUTER_API_KEY'];

  final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final body = json.encode({
    "model": "openrouter/gpt-3.5-turbo",
    "messages": [
      {
        "role": "system",
        "content":
            "You are Zeyquorra, an AI career advisor for Ugandan secondary school students.",
      },
      {"role": "user", "content": question},
    ],
  });

  final response = await http.post(uri, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['choices'][0]['message']['content'];
  } else {
    return "Sorry, I couldn't fetch career advice right now.";
  }
}
