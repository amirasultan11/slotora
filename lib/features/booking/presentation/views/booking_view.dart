import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../shared/widgets/glass_toast.dart';
import '../cubit/booking_cubit.dart';
import '../widgets/app_drawer.dart';
import '../widgets/booking_header.dart';
import '../widgets/booking_summary.dart';
import '../widgets/confirm_booking_button.dart';
import '../widgets/duration_selector.dart';
import '../widgets/schedule_view.dart';

/// Main screen for Slotora appointment booking.
///
/// Provides its own [BookingCubit] via [BlocProvider].
/// Reads [ThemeCubit] and [LocaleCubit] from the widget tree (provided in main).
class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>(
      create: (_) => getIt<BookingCubit>(),
      child: const _BookingViewContent(),
    );
  }
}

class _BookingViewContent extends StatefulWidget {
  const _BookingViewContent();

  @override
  State<_BookingViewContent> createState() => _BookingViewContentState();
}

class _BookingViewContentState extends State<_BookingViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleConfirm(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    final state = cubit.state;
    final l10n = AppLocalizations.of(context);

    if (!state.hasSelection) {
      GlassToast.show(
        context,
        type: ToastType.warning,
        title: l10n.toastErrorTitle,
        description: l10n.validationMessage(state.validationResult.status),
      );
      return;
    }

    if (!state.validationResult.isValid) {
      GlassToast.show(
        context,
        type: ToastType.error,
        title: l10n.toastErrorTitle,
        description: l10n.validationMessage(state.validationResult.status),
      );
      return;
    }

    final isArabic = context.read<LocaleCubit>().state.isArabic;
    final booking = cubit.confirmBooking();
    if (booking != null) {
      final startStr = TimeFormatter.formatTime(
        booking.startTime,
        isArabic: isArabic,
      );
      final endStr = TimeFormatter.formatTime(
        booking.endTime,
        isArabic: isArabic,
      );

      GlassToast.show(
        context,
        type: ToastType.success,
        title: l10n.toastSuccessTitle,
        description: '$startStr — $endStr',
      );
    }
  }

  void _handleResetSchedule(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    context.read<BookingCubit>().resetSchedule();
    GlassToast.show(
      context,
      type: ToastType.info,
      title: l10n.baselineRestoredToast,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
          endDrawer: AppDrawer(
            onResetSchedule: () => _handleResetSchedule(context),
          ),
          body: Column(
            children: [
              BookingHeader(
                onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
                onReset: () => context.read<BookingCubit>().resetSelection(),
                canReset:
                    state.hasSelection ||
                    state.selectedDuration.duration !=
                        const Duration(minutes: 30),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DurationSelector(
                            selectedDuration: state.selectedDuration,
                            onDurationChanged: context
                                .read<BookingCubit>()
                                .selectDuration,
                          ),
                          const SizedBox(height: 18),
                          ScheduleView(
                            slots: state.slots,
                            selectedStart: state.selectedStart,
                            selectedSlots: state.selectedSlots,
                            validStartTimes: state.validStartTimes,
                            onSelectSlot: context
                                .read<BookingCubit>()
                                .selectStartTime,
                          ),
                          const SizedBox(height: 20),
                          BookingSummary(
                            startTime: state.selectedStart,
                            endTime: state.calculatedEnd,
                            duration: state.selectedDuration,
                            validationResult: state.validationResult,
                          ),
                          const SizedBox(height: 18),
                          ConfirmBookingButton(
                            isValid: state.isBookingValid,
                            hasSelection: state.hasSelection,
                            onConfirm: () => _handleConfirm(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
