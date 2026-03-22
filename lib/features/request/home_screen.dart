import 'package:crudops_application/features/request/request.dart';
import 'package:crudops_application/features/request/request_notifier.dart';
import 'package:crudops_application/features/request/request_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
// Assuming these are your local imports
// import 'package:crudops_application/features/request/request.dart';
// import 'package:crudops_application/features/request/request_notifier.dart';
// import 'package:crudops_application/features/request/request_overlay.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light neutral background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
        title: const Text(
          "PriorityAssist",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {}, // Optional: filter or jump to history
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Section: Active Jobs
          _buildHeader("Active Job"),
          SliverToBoxAdapter(
            child: requests.any((r) => r.status == RequestStatus.in_progress)
                ? Column(
                    children: requests
                        .where((r) => r.status == RequestStatus.in_progress)
                        .map((r) => _RequestCard(request: r, isActive: true))
                        .toList(),
                  )
                : _buildEmptyState("No active jobs"),
          ),

          // Section: Queue
          _buildHeader("Queue"),
          SliverList(
            delegate: SliverChildListDelegate(
              requests
                  .where((r) => r.status == RequestStatus.pending)
                  .map((r) => _RequestCard(request: r))
                  .toList(),
            ),
          ),

          // Section: History
          _buildHeader("History"),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 100), // Space for FAB
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                requests
                    .where((r) =>
                        r.status == RequestStatus.completed ||
                        r.status == RequestStatus.declined ||
                        r.status == RequestStatus.expired)
                    .map((r) => _HistoryTile(request: r))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent[700],
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
        label: const Text("New Request", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Helper to build section titles
  Widget _buildHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(message, style: TextStyle(color: Colors.grey[400])),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final Request request;
  final bool isActive;

  const _RequestCard({required this.request, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? Colors.blue.shade200 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.blue : Colors.grey[200],
          child: Icon(
            isActive ? Icons.bolt : Icons.hourglass_empty,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
        title: Text(
          "ID: ${request.id.substring(0, 8)}...",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Expires in ${request.timeLeft}s"),
        trailing: isActive
            ? const Badge(label: Text("LIVE"), backgroundColor: Colors.red)
            : Icon(Icons.chevron_right, color: Colors.grey[400]),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final Request request;
  const _HistoryTile({required this.request});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (request.status) {
      case RequestStatus.completed: statusColor = Colors.green; break;
      case RequestStatus.declined: statusColor = Colors.red; break;
      default: statusColor = Colors.grey;
    }

    return ListTile(
      title: Text("Request #${request.id.substring(0, 5)}"),
      subtitle: Text(request.status.name),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          request.status.name,
          style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}