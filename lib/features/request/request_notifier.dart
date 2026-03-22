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

  void addRequest(Request request) {
    state = [...state, request];
    startTimer(request.id);
  }

  void startTimer(String id) {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.map((r) {
        if (r.id == id && r.timeLeft > 0) {
          return r.copyWith(timeLeft: r.timeLeft - 1);
        }
        return r;
      }).toList();

      final req = state.firstWhere((r) => r.id == id);

      if (req.timeLeft == 0 && req.status == RequestStatus.pending) {
        updateStatus(id, RequestStatus.expired);
        timer.cancel();
      }
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
  if (hasActiveJob()) {
    // move to queue (keep as pending)
    return;
  }

  updateStatus(id, RequestStatus.in_progress);
}

void declineRequest(String id) {
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
}