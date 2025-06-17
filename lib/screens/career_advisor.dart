import 'package:flutter/material.dart';
import 'package:zeyquorra/services/ai_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CareerAdvisor extends StatefulWidget {
  const CareerAdvisor({super.key});

  @override
  _CareerAdvisorState createState() => _CareerAdvisorState();
}

class _CareerAdvisorState extends State<CareerAdvisor> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isTyping = false;

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': userMessage});
      _controller.clear();
      isTyping = true;
    });

    final aiResponse = await getCareerAdvice(userMessage);

    setState(() {
      messages.add({'role': 'ai', 'text': aiResponse});
      isTyping = false;
    });

    await Supabase.instance.client.from('messages').insert({
      'username': 'student_001',
      'question': userMessage,
      'response': aiResponse,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("💬 Ask Zeyquorra")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isTyping) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0, top: 10),
                        child: Text("🤖", style: TextStyle(fontSize: 20)),
                      ),
                      SpinKitThreeBounce(
                        color: Colors.deepPurple,
                        size: 20.0,
                      ),
                    ],
                  );
                }

                final msg = messages[index];
                final isUser = msg['role'] == 'user';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.grey[300] : Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUser ? "🧑‍🎓 " : "🤖 ",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child: Text(
                          msg['text']!,
                          style: TextStyle(
                            color: isUser ? Colors.black87 : Colors.deepPurple[900],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your question...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
