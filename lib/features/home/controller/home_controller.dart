import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/home/repository/home_repository.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return HomeController(
    homeRepository: homeRepository,
    ref: ref,
  );
});

final getNCCountByUserId = StreamProvider<int>((ref) {
  return ref.watch(homeControllerProvider.notifier).getNCCountByUserId();
});

final getInspectionCountByUserId = StreamProvider<int>((ref) {
  return ref
      .watch(homeControllerProvider.notifier)
      .getInspectionCountByUserId();
});

final getSafetyCountByUserId = StreamProvider<int>((ref) {
  return ref.watch(homeControllerProvider.notifier).getSafetyCountByUserId();
});

final get8DCountByUserId = StreamProvider<int>((ref) {
  return ref.watch(homeControllerProvider.notifier).get8DCountByUserId();
});

class HomeController extends StateNotifier<bool> {
  final HomeRepository _homeRepository;
  final Ref _ref;

  HomeController({
    required HomeRepository homeRepository,
    required Ref ref,
  })  : _homeRepository = homeRepository,
        _ref = ref,
        super(false);

  //get stream of nc count by user id
  Stream<int> getNCCountByUserId() {
    //final user = _ref.read(userProvider)!;
    //print(user.toMap());
    return _homeRepository.getNCCountByUserId(
      'windsy',
      'mPO5hxtctRWsO8LVkWVnLIBYcBm1',
    );
  }

  //get stream of inspection count by user id
  Stream<int> getInspectionCountByUserId() {
    //final user = _ref.read(userProvider)!;
    //print(user.toMap());
    return _homeRepository.getInspectionCountByUserId(
      'windsy',
      'mPO5hxtctRWsO8LVkWVnLIBYcBm1',
    );
  }

  //get stream of safety count by user id
  Stream<int> getSafetyCountByUserId() {
    //final user = _ref.read(userProvider)!;
    //print(user.toMap());
    return _homeRepository.getSafetyCountByUserId(
      'windsy',
      'mPO5hxtctRWsO8LVkWVnLIBYcBm1',
    );
  }

  //get stream of 8d count by user id
  Stream<int> get8DCountByUserId() {
    //final user = _ref.read(userProvider)!;
    //print(user.toMap());
    return _homeRepository.get8DCountByUserId(
      'windsy',
      'mPO5hxtctRWsO8LVkWVnLIBYcBm1',
    );
  }
}
