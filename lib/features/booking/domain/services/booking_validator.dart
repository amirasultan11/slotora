// TODO: BookingValidator — all validation logic (range, availability, XOX gap)
sealed class BookingResult {
  const BookingResult();
}

//Success
class BookingSuccess extends BookingResult {
  const BookingSuccess();
}

//failure
class BookingFailure extends BookingResult {
  final String reason;
  const BookingFailure(this.reason);
}
