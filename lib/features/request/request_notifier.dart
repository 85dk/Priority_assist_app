import 'dart:async';
import 'package:crudops_application/features/request/request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';


final requestProvider =
    StateNotifierProvider<RequestNotifier, List<Request>>(
        (ref) => RequestNotifier());

class RequestNotifier extends StateNotifier<List<Request>> {
  RequestNotifier() : super([]);

  Timer? timer;
  final Map<String, Timer> _timers = {};

  void addRequest(Request request) {
    state = [...state, request];
    startTimer(request.id);
  }

  void startTimer(String id) {
  _timers[id]?.cancel();

  _timers[id] = Timer.periodic(const Duration(seconds: 1), (timer) {
    final request = state.firstWhere((r) => r.id == id);

    if (request.timeLeft <= 0) {
      updateStatus(id, RequestStatus.expired);
      timer.cancel();
      return;
    }

    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(timeLeft: r.timeLeft - 1);
      }
      return r;
    }).toList();
  });
}

  void updateStatus(String id, RequestStatus status) {
    state = state.map((r) {
      if (r.id == id) {
        return r.copyWith(status: status);
      }
      return r;
    }).toList();
  }
  bool hasActiveJob() {
  return state.any((r) => r.status == RequestStatus.in_progress);
}

void acceptRequest(String id) {
  if (hasActiveJob()) return;

  _timers[id]?.cancel();

  state = state.map((r) {
    if (r.id == id) {
      return r.copyWith(status: RequestStatus.in_progress);
    }
    return r;
  }).toList();
}
void declineRequest(String id) {
  _timers[id]?.cancel();
  updateStatus(id, RequestStatus.declined);
}

void completeRequest(String id) {
  updateStatus(id, RequestStatus.completed);
}

void cancelByCustomer(String id) {
  updateStatus(id, RequestStatus.cancelledByCustomer);
}
void saveData() async {
  final box = await Hive.openBox('requests');
  box.put('data', state.map((e) => e.id).toList());
}
void activateNextFromQueue() {
  final pendingRequests = state.where((r) => r.status == RequestStatus.pending);

  if (pendingRequests.isNotEmpty) {
    final next = pendingRequests.first;
    updateStatus(next.id, RequestStatus.in_progress);
  }
}
}