import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';

import 'package:windsy_solve/features/inspection/repository/inspection_repository.dart';
import 'package:windsy_solve/models/inspection_model.dart';
import 'package:windsy_solve/models/inspection_templates_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

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

final getUserInspectionProvider = StreamProvider<List<InspectionModel>>((ref) {
  return ref
      .watch(inspectionControllerProvider.notifier)
      ._getInspectionsCreatedByUser();
});

final getInspectionTemplatesProvider =
    StreamProvider<List<InspectionTemplates>>((ref) {
  return ref
      .watch(inspectionControllerProvider.notifier)
      .getInspectionTemplates();
});

final getInspectionSectionsProvider =
    StreamProvider.family((ref, String inspectionId) {
  return ref
      .watch(inspectionControllerProvider.notifier)
      .getInspectionSections(inspectionId);
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

  //create new inspection
  void createNC(BuildContext context, String companyId,
      InspectionModel inspection) async {
    state = true;
    final res =
        await _inspectionRepository.createInspection(companyId, inspection);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'I-$r created successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  //close inspection
  void closeNC(
      BuildContext context, String companyId, String inspectionId) async {
    state = true;
    final user = _ref.watch(userProvider)!;
    final res = await _inspectionRepository.closeInspection(
      companyId,
      user.uid,
      inspectionId,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, r.toString());
        Routemaster.of(context).pop();
      },
    );
  }

  //delete inspection
  void deleteNC(
      BuildContext context, String companyId, String inspectionId) async {
    state = true;
    final res = await _inspectionRepository.deleteInspection(
      companyId,
      inspectionId,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, r.toString());
        Routemaster.of(context).pop();
      },
    );
  }

  //add new section
  void addSection(String inspectionId, String sectionName) async {
    final user = _ref.watch(userProvider)!;
    await _inspectionRepository.addSection(
      user.companyId,
      inspectionId,
      sectionName,
    );
  }

  //get stream of all ncs created by user
  Stream<List<InspectionModel>> _getInspectionsCreatedByUser() {
    final user = _ref.read(userProvider)!;
    return _inspectionRepository.getInspectionsCreatedByUser(
      user.companyId,
      user.uid,
    );
  }

  //get inspection templates
  Stream<List<InspectionTemplates>> getInspectionTemplates() {
    final user = _ref.watch(userProvider)!;
    return _inspectionRepository.getInspectionTemplates(user.companyId);
  }

  //get inspection sections
  Stream<List<String>> getInspectionSections(String inspectionId) {
    final user = _ref.watch(userProvider)!;
    return _inspectionRepository.getInspectionSections(
      user.companyId,
      inspectionId,
    );
  }
}
