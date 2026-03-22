import 'package:crudops_application/features/request/request.dart';
import 'package:crudops_application/features/request/request_notifier.dart';
import 'package:crudops_application/features/request/request_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';


class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("PriorityAssist")),
      body: Column(
  children: [
    const SizedBox(height: 10),

    // ACTIVE JOB
    ...requests
        .where((r) => r.status == RequestStatus.in_progress)
        .map((r) => ListTile(
              title: Text("ACTIVE: ${r.id}"),
              tileColor: Colors.green.shade100,
            )),

    const Divider(),

    // QUEUE
    const Text("Queue"),
    ...requests
        .where((r) => r.status == RequestStatus.pending)
        .map((r) => ListTile(
              title: Text("Queued: ${r.id}"),
            )),

    const Divider(),

    // HISTORY
    const Text("History"),
    ...requests
        .where((r) =>
            r.status == RequestStatus.completed ||
            r.status == RequestStatus.declined ||
            r.status == RequestStatus.expired)
        .map((r) => ListTile(
              title: Text("${r.id}"),
              subtitle: Text(r.status.name),
            )),
  ],
),
      //  ListView(
      //   children: requests.map((r) {
      //     return ListTile(
      //       title: Text("Request ${r.id}"),
      //       subtitle: Text(r.status.toString()),
      //     );
      //   }).toList(),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final id = const Uuid().v4();

          ref.read(requestProvider.notifier).addRequest(
                Request(
                  id: id,
                  status: RequestStatus.pending,
                  timeLeft: 45,
                ),
              );
              showRequestOverlay(context, id); 
        },
        child: Icon(Icons.add),
      ),
    );
  }
}