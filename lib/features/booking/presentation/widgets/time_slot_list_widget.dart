import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import 'slot_tile.dart';

class TimeSlotListWidget extends StatelessWidget {
  const TimeSlotListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 2.5,
          ),
          itemCount: state.slots.length,
          itemBuilder: (context, index) {
            final slot = state.slots[index];
            final isPrimarySelected = state.selectedStartIndex == index;
            
            bool isPreviewMode = false;
            if (state.selectedStartIndex != null) {
              final endIndex = state.selectedStartIndex! + state.selectedDuration.slotsCount;
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
