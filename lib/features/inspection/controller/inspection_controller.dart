import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';

import 'package:windsy_solve/features/inspection/repository/inspection_repository.dart';

final inspectionControllerProvider =
    StateNotifierProvider<InspectionController, bool>((ref) {
  final inspectionRepository = ref.watch(inspectionRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return InspectionController(
    ref: ref,
    inspectionRepository: inspectionRepository,
    storageRepository: storageRepository,
  );
});

class InspectionController extends StateNotifier<bool> {
  final InspectionRepository _inspectionRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  InspectionController({
    required InspectionRepository inspectionRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _inspectionRepository = inspectionRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);
}
