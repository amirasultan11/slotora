import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slotora/features/booking/presentation/widgets/slot_tile.dart';

import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class TimeSlotListWidget extends StatelessWidget {
  const TimeSlotListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          itemCount: state.slots.length,
          separatorBuilder: (context, index) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final slot = state.slots[index];
            final isPrimarySelected = state.selectedStartIndex == index;

            bool isPreviewMode = false;
            if (state.selectedStartIndex != null) {
              final endIndex =
                  state.selectedStartIndex! + state.selectedDuration.slotsCount;
              if (index > state.selectedStartIndex! && index < endIndex) {
                isPreviewMode = true;
              }
            }

            return SlotTile(
              slot: slot,
              isValidStart: state.validStartIndices.contains(index),
              isSelectedRange: isPrimarySelected || isPreviewMode,
              onTap: () => context.read<BookingCubit>().selectStartTime(index),
            );
          },
        );
      },
    );
  }
}
