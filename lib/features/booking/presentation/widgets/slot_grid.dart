import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import 'slot_tile.dart';

class SlotGrid extends StatelessWidget {
  const SlotGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemCount: state.slots.length,
          itemBuilder: (context, index) {
            final slot = state.slots[index];
            final isValidStart = state.validStartIndices.contains(index);
            final isSelectedRange = state.selectedStartIndex != null &&
                index >= state.selectedStartIndex! &&
                index < state.selectedStartIndex! + state.selectedDuration.slotsCount;

            return SlotTile(
              slot: slot,
              isValidStart: isValidStart,
              isSelectedRange: isSelectedRange,
              onTap: () => context.read<BookingCubit>().selectStartTime(index),
            );
          },
        );
      },
    );
  }
}
