sealed class BookingResult {
  const BookingResult();
}

class BookingSuccess extends BookingResult {
  const BookingSuccess();
}

class BookingFailure extends BookingResult {
  final String reason;
  const BookingFailure(this.reason);
}
