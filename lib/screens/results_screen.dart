import 'package:flutter/material.dart';
import 'package:zeyquorra/screens/career_advisor.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zeyquorra Career Advisor')),
      body: Center(
        child: ElevatedButton(
          child: Text("Start Career Chat"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CareerAdvisor()),
            );
          },
        ),
      ),
    );
  }
}
