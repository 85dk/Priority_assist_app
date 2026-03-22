import 'package:crudops_application/features/request/request.dart';
import 'package:crudops_application/features/request/request_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveJobScreen extends ConsumerStatefulWidget {
  final String id;

  const ActiveJobScreen({required this.id, super.key});

  @override
  ConsumerState<ActiveJobScreen> createState() => _ActiveJobScreenState();
}

class _ActiveJobScreenState extends ConsumerState<ActiveJobScreen> {
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
            // ✅ FINAL STEP → COMPLETE JOB

            ref.read(requestProvider.notifier).updateStatus(
                  widget.id,
                  RequestStatus.completed,
                );
               ref.read(requestProvider.notifier).activateNextFromQueue();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Job Completed")),
            );

            Navigator.pop(context); // back to home
          } else {
            nextStep();
          }
        },
        onStepCancel: previousStep,
        steps: [
          Step(
            title: const Text("On the Way"),
            content: const Text("Map Placeholder"),
            isActive: currentStep >= 0,
          ),
          Step(
            title: const Text("Checklist"),
            content: const Text("Task Checklist"),
            isActive: currentStep >= 1,
          ),
          Step(
            title: const Text("Complete Job"),
            content: const Text("Finish Job"),
            isActive: currentStep >= 2,
          ),
        ],
      ),
    );
  }
}