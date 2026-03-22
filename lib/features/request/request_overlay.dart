import 'package:crudops_application/features/request/request.dart';
import 'package:crudops_application/features/request/request_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void showRequestOverlay(BuildContext context, String id) {
  showDialog(
    context: context,
    builder: (_) => RequestOverlay(id: id),
  );
}

class RequestOverlay extends ConsumerWidget {
  final String id;

  const RequestOverlay({required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(requestProvider)
        .firstWhere((r) => r.id == id);

    return AlertDialog(
      title: Text("Incoming Request"),
      content: Text("Time left: ${request.timeLeft}"),
      actions: [
        ElevatedButton(
          onPressed: () {
            ref
                .read(requestProvider.notifier)
                .updateStatus(id, RequestStatus.accepted);

            Navigator.pop(context);
          },
          child: Text("Accept"),
        ),
        ElevatedButton(
          onPressed: () {
            ref
                .read(requestProvider.notifier)
                .updateStatus(id, RequestStatus.declined);

            Navigator.pop(context);
          },
          child: Text("Decline"),
        ),
      ],
    );
  }
}