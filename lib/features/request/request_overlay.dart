import 'package:crudops_application/features/request/active_job_screen.dart';
import 'package:crudops_application/features/request/request_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void showRequestOverlay(BuildContext context, String id) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Request",
    pageBuilder: (_, __, ___) {
      return RequestOverlay(id: id);
    },
  );
}

class RequestOverlay extends ConsumerWidget {
  final String id;

  const RequestOverlay({required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(requestProvider)
        .firstWhere((r) => r.id == id);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("🚨 Emergency Request",
                  style: TextStyle(fontSize: 20)),

              const SizedBox(height: 20),

              Text("Time left: ${request.timeLeft}s",
                  style: const TextStyle(fontSize: 24)),

              const SizedBox(height: 20),

              LinearProgressIndicator(
                value: request.timeLeft / 45,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(requestProvider.notifier)
                          .acceptRequest(id);

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    child: const Text("ACCEPT"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(requestProvider.notifier)
                          .declineRequest(id);

                      Navigator.pop(context);
                        Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ActiveJobScreen(id: id),
    ));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    child: const Text("DECLINE"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}