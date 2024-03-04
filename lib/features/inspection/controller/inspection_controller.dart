import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/inspection/repository/inspection_repository.dart';
import 'package:windsy_solve/models/inspection/inspection_model.dart';
import 'package:windsy_solve/models/inspection/inspection_templates_model.dart';
import 'package:windsy_solve/models/inspection/section_model.dart';

import 'package:windsy_solve/utils/snack_bar.dart';

final inspectionControllerProvider =
    StateNotifierProvider<InspectionController, bool>((ref) {
  final inspectionRepository = ref.watch(inspectionRepositoryProvider);
  return InspectionController(
    ref: ref,
    inspectionRepository: inspectionRepository,
  );
});

final inspectionProvider = Provider<InspectionModel>(
  (ref) => InspectionModel(
    id: '',
    title: '',
    problemDescription: '',
    status: '',
    severity: 0,
    category: '',
    customer: '',
    externalAuditor: '',
    sections: [],
    supplier: '',
    windFarm: '',
    turbineNo: '',
    createdBy: '',
    createdAt: DateTime.now(),
    updatedBy: '',
    updatedAt: DateTime.now(),
  ),
);

final getInspectionbyIdProvider =
    FutureProvider.autoDispose.family((ref, String inspectionId) async {
  final inspectionController = ref.watch(inspectionControllerProvider.notifier);
  return inspectionController.getInspectionbyId(inspectionId);
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

final checkInspectionIdExistsProvider = StreamProvider.family(
  (ref, String inspectionId) {
    return ref
        .watch(inspectionControllerProvider.notifier)
        .checkIfInspectionIdExists(inspectionId);
  },
);

final getChecklistsFromSectionProvider =
    StreamProvider.family((ref, SectionModel section) {
  return ref
      .watch(inspectionControllerProvider.notifier)
      .getChecklistsFromSection(section);
});

class InspectionController extends StateNotifier<bool> {
  final InspectionRepository _inspectionRepository;
  final Ref _ref;

  InspectionController({
    required InspectionRepository inspectionRepository,
    required Ref ref,
  })  : _inspectionRepository = inspectionRepository,
        _ref = ref,
        super(false);

  //create new inspection
  void createNC(
    BuildContext context,
    String companyId,
    InspectionModel inspection,
  ) async {
    state = true;
    final res = await _inspectionRepository.createInspection(
      companyId,
      inspection,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(
          context,
          'Inspection - $r created successfully!',
          SnackBarType.success,
        );
        Routemaster.of(context).pop();
      },
    );
  }

  void updateInspection(
    BuildContext context,
    InspectionModel inspection,
  ) async {
    state = true;
    final user = _ref.watch(userProvider)!;
    final res = await _inspectionRepository.updateInspection(
      user.companyId,
      inspection,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(context, 'Inspection: $r updated successfully',
            SnackBarType.success);
        Routemaster.of(context).pop();
      },
    );
  }

  //close inspection
  void closeInspection(
    BuildContext context,
    String inspectionId,
  ) async {
    state = true;
    final user = _ref.watch(userProvider)!;
    final res = await _inspectionRepository.closeInspection(
      user.companyId,
      user.uid,
      inspectionId,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(context, r, SnackBarType.success);
        Routemaster.of(context).pop();
      },
    );
  }

  //delete inspection
  void deleteInspection(
    BuildContext context,
    String inspectionId,
  ) async {
    state = true;
    final user = _ref.watch(userProvider)!;
    final res = await _inspectionRepository.deleteInspection(
      user.companyId,
      inspectionId,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) => showSnackBar(context, r, SnackBarType.success),
    );
  }

  //update section in inspection
  void updateSection(
    BuildContext context,
    inspectionId,
    String sectionName,
  ) async {
    final user = _ref.watch(userProvider)!;
    final res = await _inspectionRepository.updateSection(
      user.companyId,
      inspectionId,
      sectionName,
    );
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(
          context,
          "Section: $sectionName added",
          SnackBarType.success,
        );
        Routemaster.of(context).pop();
      },
    );
  }

  //add new section
  void addSection(
    BuildContext context,
    String inspectionId,
    String sectionName,
  ) async {
    final user = _ref.watch(userProvider)!;
    await _inspectionRepository
        .checkIfSectionExists(
      user.companyId,
      inspectionId,
      sectionName,
    )
        .then(
      (isExists) async {
        if (isExists) {
          showSnackBar(
              context, "Section id already exists", SnackBarType.warning);
          Routemaster.of(context).pop();
        } else {
          final res = await _inspectionRepository.addSection(
            user.companyId,
            user.displayName,
            inspectionId,
            sectionName,
          );
          res.fold(
            (l) => showSnackBar(context, l.message, SnackBarType.error),
            (r) {
              showSnackBar(context, r.toString(), SnackBarType.success);
              Routemaster.of(context).pop();
            },
          );
        }
      },
    );
  }

  void deleteSection(
      BuildContext context, String inspectionId, String sectionName) async {
    final user = _ref.watch(userProvider)!;
    state = true;
    final res = await _inspectionRepository.deleteSection(
      user.companyId,
      inspectionId,
      sectionName,
    );

    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(context, r.toString(), SnackBarType.success);
        Routemaster.of(context).pop();
      },
    );
  }

  //add new checklist
  void addChecklist(
    BuildContext context,
    String inspectionId,
    String sectionName,
    String checkName,
  ) async {
    final user = _ref.watch(userProvider)!;
    await _inspectionRepository
        .checkIfChecklistExists(
      user.companyId,
      inspectionId,
      sectionName,
      checkName,
    )
        .then((isExists) async {
      if (isExists) {
        showSnackBar(
            context, "Check list id already exists", SnackBarType.warning);
        Routemaster.of(context).pop();
      } else {
        final res = await _inspectionRepository.addChecklist(
          user.companyId,
          inspectionId,
          sectionName,
          checkName,
        );
        res.fold(
          (l) => showSnackBar(context, l.message, SnackBarType.error),
          (r) {
            showSnackBar(context, r.toString(), SnackBarType.success);
            Routemaster.of(context).pop();
          },
        );
      }
    });
  }

  //get future of nc by id
  Future<InspectionModel> getInspectionbyId(String inspectionId) async {
    //final user = _ref.read(userProvider)!;
    final inspectionModel =
        await _inspectionRepository.getInspectionbyId('windsy', inspectionId);
    return InspectionModel.fromMap(
      inspectionModel.data() as Map<String, dynamic>,
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

  //check if inspection id exists as a stream
  Stream<bool> checkIfInspectionIdExists(String inspectionId) {
    final user = _ref.watch(userProvider)!;
    return _inspectionRepository.checkIfInspectionIdExists(
      user.companyId,
      inspectionId,
    );
  }

  //get checklists from section
  Stream<List<String>> getChecklistsFromSection(
    SectionModel section,
  ) {
    final user = _ref.watch(userProvider)!;

    return _inspectionRepository.getChecklistsFromSection(
      user.companyId,
      section.inspectionId,
      section.sectionName,
    );
  }
}
