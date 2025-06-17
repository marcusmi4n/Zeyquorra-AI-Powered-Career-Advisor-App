import 'package:flutter/material.dart';
import 'package:zeyquorra/services/ai_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CareerAdvisor extends StatefulWidget {
  @override
  _CareerAdvisorState createState() => _CareerAdvisorState();
}

class _CareerAdvisorState extends State<CareerAdvisor> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': userMessage});
      _controller.clear();
    });

    final aiResponse = await getCareerAdvice(userMessage);

    setState(() {
      messages.add({'role': 'ai', 'text': aiResponse});
    });

    await Supabase.instance.client.from('messages').insert({
      'user': 'student_001',
      'question': userMessage,
      'response': aiResponse,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ask Zeyquorra")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg['text']!,
                      style: TextStyle(
                        color: msg['role'] == 'user'
                            ? Colors.black
                            : Colors.deepPurple,
                      )),
                  leading: msg['role'] == 'ai'
                      ? Icon(Icons.smart_toy)
                      : Icon(Icons.person),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        InputDecoration(hintText: 'What do you want to know?'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
