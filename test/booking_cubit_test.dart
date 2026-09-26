import 'package:flutter_test/flutter_test.dart';

import 'package:slotora/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:slotora/features/booking/domain/models/booking_duration.dart';

void main() {
  group('BookingCubit', () {
    late BookingCubit cubit;

    setUp(() {
      cubit = BookingCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state.selectedDuration, BookingDuration.thirtyMin);
      expect(cubit.state.selectedStartIndex, isNull);
      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.slots.length, 18);
    });

    test('changeDuration updates duration and recalculates valid starts', () {
      cubit.changeDuration(BookingDuration.oneHour);
      expect(cubit.state.selectedDuration, BookingDuration.oneHour);
      expect(cubit.state.validStartIndices.length, 7);
    });

    test('selectStartTime updates selected index when valid', () {
      cubit.selectStartTime(0);
      expect(cubit.state.selectedStartIndex, 0);
    });

    test('selectStartTime does nothing for invalid start', () {
      cubit.changeDuration(BookingDuration.twoHours);
      cubit.selectStartTime(17); // Invalid because 17 + 4 > 18
      
      expect(cubit.state.selectedDuration, BookingDuration.twoHours);
      expect(cubit.state.validStartIndices, isNot(contains(17)));
      expect(cubit.state.selectedStartIndex, isNull);
    });
  });
}
