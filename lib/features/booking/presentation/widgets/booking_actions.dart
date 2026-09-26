import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../../../../core/utils/app_colors.dart';

class BookingActions extends StatelessWidget {
  const BookingActions({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingCubit>();

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: state.hasSelection ? cubit.confirmBooking : null,
                child: const Text('Confirm Booking'),
              ),
            ),
            SizedBox(width: 10.w),
            IconButton(
              onPressed: state.canUndo ? cubit.undoLastBooking : null,
              icon: const Icon(Icons.undo),
              style: IconButton.styleFrom(backgroundColor: AppColors.surface),
            ),
            SizedBox(width: 10.w),
            IconButton(
              onPressed: cubit.reset,
              icon: const Icon(Icons.refresh),
              style: IconButton.styleFrom(backgroundColor: AppColors.surface),
            ),
          ],
        );
      },
    );
  }
}
