import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/analytics/repository/analytics_repository.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';

final analyticsControllerProvider =
    StateNotifierProvider<AnalyticsController, bool>((ref) {
  final analyticsRepository = ref.watch(analyticsRepositoryProvider);
  return AnalyticsController(
    analyticsRepository: analyticsRepository,
    ref: ref,
  );
});

final getNCCountByMonthProvider = StreamProvider.family((ref, int year) {
  final analyticsController = ref.watch(analyticsControllerProvider.notifier);
  return analyticsController.getNCCountByMonth(year);
});

final getNCCountByStatusProvider = StreamProvider.family((ref, int year) {
  final analyticsController = ref.watch(analyticsControllerProvider.notifier);
  return analyticsController.getNCCountByStatus(year);
});

class AnalyticsController extends StateNotifier<bool> {
  final AnalyticsRepository _analyticsRepository;
  final Ref _ref;

  AnalyticsController(
      {required AnalyticsRepository analyticsRepository, required Ref ref})
      : _analyticsRepository = analyticsRepository,
        _ref = ref,
        super(false);

  Stream<Map<int, int>> getNCCountByMonth(int year) {
    final user = _ref.watch(userProvider)!;
    return _analyticsRepository.getNCCountByMonth(user.companyId, year);
  }

  Stream<Map<String, int>> getNCCountByStatus(int year) {
    final user = _ref.watch(userProvider)!;
    return _analyticsRepository.getNCCountByStatus(user.companyId, year);
  }
}
