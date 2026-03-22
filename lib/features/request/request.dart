enum RequestStatus {
  pending,
  accepted,
  declined,
  expired,
  in_progress,
  completed,
  cancelledByCustomer
}

class Request {
  final String id;
  final RequestStatus status;
  final int timeLeft;

  Request({
    required this.id,
    required this.status,
    required this.timeLeft,
  });

  Request copyWith({
    RequestStatus? status,
    int? timeLeft,
  }) {
    return Request(
      id: id,
      status: status ?? this.status,
      timeLeft: timeLeft ?? this.timeLeft,
    );
  }
}