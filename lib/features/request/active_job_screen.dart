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
      setState(() => currentStep++);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          "Job #${widget.id.substring(0, 6).toUpperCase()}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 1. MODERN PROGRESS HEADER
          _buildProgressHeader(),

          // 2. MAIN CONTENT AREA
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: _buildStepContent(),
              ),
            ),
          ),

          // 3. NAVIGATION BUTTONS (Replacing Stepper controls)
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          bool isActive = index <= currentStep;
          bool isCurrent = index == currentStep;
          return Row(
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: isCurrent ? Colors.blueAccent : (isActive ? Colors.blueAccent.withOpacity(0.2) : Colors.grey[200]),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isActive && !isCurrent
                          ? const Icon(Icons.check, color: Colors.blueAccent, size: 16)
                          : Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: isCurrent ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              if (index < 2)
                Container(
                  width: 60,
                  height: 2,
                  color: index < currentStep ? Colors.blueAccent : Colors.grey[200],
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildContent(Icons.map_outlined, "On the Way", "Head to the client's location as per the map navigation.");
      case 1:
        return _buildContent(Icons.checklist_rtl_rounded, "Checklist", "Please verify all tasks are performed before finalizing.");
      case 2:
        return _buildContent(Icons.verified_user_outlined, "Final Review", "Ensure the job quality meets standards and confirm completion.");
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildContent(IconData icon, String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: Colors.blueAccent.shade100),
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: previousStep,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Back"),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (currentStep == 2) {
                  ref.read(requestProvider.notifier).updateStatus(widget.id, RequestStatus.completed);
                  ref.read(requestProvider.notifier).activateNextFromQueue();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job Completed")));
                  Navigator.pop(context);
                } else {
                  nextStep();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                currentStep == 2 ? "FINISH JOB" : "NEXT STEP",
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}