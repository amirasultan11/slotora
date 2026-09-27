import 'package:get_it/get_it.dart';

import '../../features/booking/data/datasources/local_schedule_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/services/booking_calculator.dart';
import '../../features/booking/domain/services/booking_validator.dart';
import '../../features/booking/presentation/cubit/booking_cubit.dart';
import '../localization/locale_cubit.dart';
import '../theme/theme_cubit.dart';

/// Singleton GetIt service locator instance.
final GetIt getIt = GetIt.instance;

/// Registers all application dependencies in the correct order.
///
/// Dependency graph:
///   LocalScheduleDataSource
///     → BookingRepositoryImpl (implements BookingRepository)
///         → BookingCalculator
///         → BookingValidator
///             → BookingCubit (factory: new instance per screen lifecycle)
///
/// ThemeCubit and LocaleCubit are singletons (application-lifetime state).
void configureDependencies() {
  // Infrastructure
  getIt.registerLazySingleton<LocalScheduleDataSource>(
    () => LocalScheduleDataSource(),
  );

  // Domain services (stateless, const-constructable)
  getIt.registerLazySingleton<BookingCalculator>(
    () => const BookingCalculator(),
  );
  getIt.registerLazySingleton<BookingValidator>(
    () => BookingValidator(calculator: getIt<BookingCalculator>()),
  );

  // Repository (singleton to share state across the session)
  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(dataSource: getIt<LocalScheduleDataSource>()),
  );

  // Feature Cubits
  // BookingCubit is a factory so each BlocProvider creates a fresh instance.
  getIt.registerFactory<BookingCubit>(
    () => BookingCubit(
      repository: getIt<BookingRepository>(),
      calculator: getIt<BookingCalculator>(),
      validator: getIt<BookingValidator>(),
    ),
  );

  // App-level Cubits (singletons — persist for the application lifetime)
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
}
