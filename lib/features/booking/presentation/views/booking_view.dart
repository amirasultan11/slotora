import 'package:flutter/material.dart';

import '../../../../core/di/app_scope.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../domain/booking/booking_calculator.dart';
import '../../../../domain/booking/booking_validator.dart';
import '../../../../shared/widgets/glass_toast.dart';
import '../view_models/booking_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/booking_header.dart';
import '../widgets/booking_summary.dart';
import '../widgets/confirm_booking_button.dart';
import '../widgets/duration_selector.dart';
import '../widgets/schedule_view.dart';

/// Main screen for Slotora appointment booking.
class BookingView extends StatefulWidget {
  final BookingViewModel? viewModel;

  const BookingView({super.key, this.viewModel});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BookingViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel == null) {
      if (widget.viewModel != null) {
        _viewModel = widget.viewModel;
      } else {
        final scope = AppScope.of(context);
        const calculator = BookingCalculator();
        final validator = BookingValidator(calculator: calculator);
        _viewModel = BookingViewModel(
          repository: scope.bookingRepository,
          calculator: calculator,
          validator: validator,
        );
      }
    }
  }

  void _handleConfirm() {
    final vm = _viewModel;
    if (vm == null) return;

    final l10n = AppLocalizations.of(context);

    if (!vm.state.hasSelection) {
      GlassToast.show(
        context,
        type: ToastType.warning,
        title: l10n.toastErrorTitle,
        description: l10n.msgNoSelection,
      );
      return;
    }

    if (!vm.state.validationResult.isValid) {
      GlassToast.show(
        context,
        type: ToastType.error,
        title: l10n.toastErrorTitle,
        description: l10n.validationMessage(vm.state.validationResult.status),
      );
      return;
    }

    final booking = vm.confirmBooking();
    if (booking != null) {
      final startStr = TimeFormatter.formatTime(
        booking.startTime,
        isArabic: l10n.isArabic,
      );
      final endStr = TimeFormatter.formatTime(
        booking.endTime,
        isArabic: l10n.isArabic,
      );

      GlassToast.show(
        context,
        type: ToastType.success,
        title: l10n.toastSuccessTitle,
        description: '$startStr — $endStr',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = _viewModel;
    if (vm == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final scope = AppScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: vm,
      builder: (context, _) {
        final state = vm.state;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
          endDrawer: AppDrawer(
            themeController: scope.themeController,
            localizationController: scope.localizationController,
            onResetSchedule: () {
              vm.resetAll();
              GlassToast.show(
                context,
                type: ToastType.info,
                title: scope.localizationController.isArabic
                    ? 'تمت استعادة الجدول الافتراضي'
                    : 'Baseline Schedule Restored',
              );
            },
          ),
          body: Column(
            children: [
              // Top Header
              BookingHeader(
                onOpenDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
                onReset: vm.resetSelection,
                canReset:
                    state.hasSelection ||
                    state.selectedDuration.duration !=
                        const Duration(minutes: 30),
              ),

              // Scrollable Schedule Body
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
                          // 1. Duration Selector
                          DurationSelector(
                            selectedDuration: state.selectedDuration,
                            onDurationChanged: vm.selectDuration,
                          ),

                          const SizedBox(height: 18),

                          // 2. Schedule Grid
                          ScheduleView(
                            slots: state.slots,
                            selectedStart: state.selectedStart,
                            selectedSlots: state.selectedSlots,
                            validStartTimes: state.validStartTimes,
                            onSelectSlot: vm.selectStartTime,
                          ),

                          const SizedBox(height: 20),

                          // 3. Live Booking Summary
                          BookingSummary(
                            startTime: state.selectedStart,
                            endTime: state.calculatedEnd,
                            duration: state.selectedDuration,
                            validationResult: state.validationResult,
                          ),

                          const SizedBox(height: 18),

                          // 4. Confirm Booking CTA
                          ConfirmBookingButton(
                            isValid: state.isBookingValid,
                            hasSelection: state.hasSelection,
                            onConfirm: _handleConfirm,
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
