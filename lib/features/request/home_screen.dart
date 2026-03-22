import 'package:crudops_application/features/request/request.dart';
import 'package:crudops_application/features/request/request_notifier.dart';
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
      body: ListView(
        children: requests.map((r) {
          return ListTile(
            title: Text("Request ${r.id}"),
            subtitle: Text(r.status.toString()),
          );
        }).toList(),
      ),
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
        },
        child: Icon(Icons.add),
      ),
    );
  }
}