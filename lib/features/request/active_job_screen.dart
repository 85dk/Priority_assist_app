import 'package:flutter/material.dart';

class ActiveJobScreen extends StatefulWidget {
  final String id;

  const ActiveJobScreen({required this.id, super.key});

  @override
  State<ActiveJobScreen> createState() => _ActiveJobScreenState();
}

class _ActiveJobScreenState extends State<ActiveJobScreen> {
  int currentStep = 0;

  void nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Job ${widget.id}"),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep == 2) {
            // FINAL STEP → COMPLETE JOB
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Job Completed")),
            );
            Navigator.pop(context);
          } else {
            nextStep();
          }
        },
        onStepCancel: previousStep,
        steps: [
          Step(
            title: const Text("On the Way"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Customer Location"),
                SizedBox(height: 10),
                Text("Map Placeholder"),
              ],
            ),
            isActive: currentStep >= 0,
          ),
          Step(
            title: const Text("Checklist"),
            content: Column(
              children: const [
                CheckboxListTile(
                  value: false,
                  onChanged: null,
                  title: Text("Checked Tools"),
                ),
                CheckboxListTile(
                  value: false,
                  onChanged: null,
                  title: Text("Reached Location"),
                ),
              ],
            ),
            isActive: currentStep >= 1,
          ),
          Step(
            title: const Text("Complete Job"),
            content: Column(
              children: const [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Notes",
                  ),
                ),
              ],
            ),
            isActive: currentStep >= 2,
          ),
        ],
      ),
    );
  }
}