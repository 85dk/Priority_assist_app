import 'package:flutter/material.dart';

class ActiveJobScreen extends StatelessWidget {
  final String id;

  const ActiveJobScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Active Job")),
      body: Stepper(
        steps: [
          Step(title: Text("On the way"), content: Text("Navigate")),
          Step(title: Text("Checklist"), content: Text("Tasks")),
          Step(title: Text("Complete"), content: Text("Finish job")),
        ],
      ),
    );
  }
}