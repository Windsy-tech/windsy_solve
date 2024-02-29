// ignore_for_file: unnecessary_null_comparison
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pdf/src/widgets/document.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:windsy_solve/core/handler/failure.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/features/reports_dashboard/pdf/inspection/generate_inspection_pdf.dart';
import 'package:windsy_solve/features/reports_dashboard/pdf/nc/generate_nc_pdf.dart';
import 'package:windsy_solve/features/reports_dashboard/repository/reports_repository.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';
import 'package:windsy_solve/models/inspection/section_model.dart';
import 'package:windsy_solve/models/nc/nc_model.dart';
import 'package:windsy_solve/models/reports/reports_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final reportsControllerProvider =
    StateNotifierProvider<ReportsController, bool>((ref) {
  final reportsRepository = ref.watch(reportsRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ReportsController(
    reportsRepository: reportsRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getNCReportsProvider = StreamProvider((ref) {
  final reportsController = ref.watch(reportsControllerProvider.notifier);
  return reportsController.getNCReports();
});

final getInspectionReportsProvider = StreamProvider((ref) {
  final reportsController = ref.watch(reportsControllerProvider.notifier);
  return reportsController.getInspectionReports();
});

final getNCReportsCreatedByUserProvider = StreamProvider((ref) {
  final reportsController = ref.watch(reportsControllerProvider.notifier);
  return reportsController.getNCReportsCreatedByUser();
});

final getInspectionReportsCreatedByUserProvider = StreamProvider((ref) {
  final reportsController = ref.watch(reportsControllerProvider.notifier);
  return reportsController.getInspectionReportsCreatedByUser();
});

class ReportsController extends StateNotifier<bool> {
  final ReportsRepository _reportsRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  ReportsController({
    required ReportsRepository reportsRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _reportsRepository = reportsRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  //create pdf report
  void createNCReport({
    required String id,
    required String fileName,
    required String language,
    required bool includeAllAttachments,
    required String fileType,
    required BuildContext context,
  }) async {
    state = true;
    final pdf = GenerateNCPDF();
    NCModel ncData =
        await _ref.read(ncControllerProvider.notifier).getNCbyId(id);

    if (fileType == "pdf") {
      final ncPDf = await pdf.createPDF(
        id: id,
        nc: ncData,
        fileName: fileName,
      );

      final res = await saveNCReport(
        associatedTo: id,
        file: ncPDf,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'NC-$r report saved!');
          Routemaster.of(context).pop();
        },
      );
    }

    state = false;
  }

  //save NC report
  FutureEither<String> saveNCReport({
    required String associatedTo,
    required File file,
  }) async {
    try {
      final user = _ref.read(userProvider)!;
      int version = await _reportsRepository.getNCReportVersion(
        associatedTo,
        user.companyId,
      );

      ReportModel report = ReportModel(
        id: '',
        type: 'NC',
        version: version,
        title: 'Non-Conformance Report',
        associatedTo: associatedTo,
        status: 'Open',
        fileUrl: '',
        fileType: file.path.split('.').last,
        fileName: file.path.split('/').last,
        createdBy: user.uid,
        createdAt: DateTime.now(),
      );

      if (file != null) {
        Uuid uuid = const Uuid();
        report = report.copyWith(
          id: uuid.v8(),
        );
        final filePath = '${user.companyId}/nc-reports/$associatedTo';
        final res = await _storageRepository.storeFile(
          id: report.id,
          path: filePath,
          file: file,
          webFile: null,
        );

        res.fold(
          (l) {
            state = false;
            return left(Failure(message: l.message));
          },
          (r) {
            report = report.copyWith(
              fileUrl: r,
            );
          },
        );
      }

      final res = await _reportsRepository.saveNCReport(
        report,
        user.companyId,
      );
      state = false;
      return res.fold(
        (l) => left(Failure(message: l.message)),
        (r) => right(r),
      );
    } catch (e) {
      state = false;
      return left(Failure(message: e.toString()));
    }
  }

  //stream NC reports by company id
  Stream<List<ReportModel>> getNCReports() {
    final user = _ref.read(userProvider)!;
    return _reportsRepository.getNCReports(user.companyId);
  }

  //stream NC reports generated by user
  Stream<List<ReportModel>> getNCReportsCreatedByUser() {
    final user = _ref.read(userProvider)!;
    return _reportsRepository.getNCReportsCreatedByUser(
      user.companyId,
      user.uid,
    );
  }

  //Create Inspection report
  void createInspectionReport({
    required String id,
    required String fileName,
    required String fileType,
    required String language,
    required bool includeAllAttachments,
    required String confidentialityLevel,
    required BuildContext context,
  }) async {
    state = true;
    final inspection = GenerateInspectionPDF();
    final inspectionData = await _ref
        .read(inspectionControllerProvider.notifier)
        .getInspectionbyId(id);

    final user = _ref.read(userProvider)!;
    final pdf = Document();

    if (fileType == "pdf") {
      late final File inspectionPDF;

      await inspection.createPDF(
        pdf: pdf,
        id: id,
        user: user,
        inspection: inspectionData,
        confidentialityLevel: confidentialityLevel,
      );

      for (var i = 0; i < inspectionData.sections!.length; i++) {
        final section = inspectionData.sections![i];
        final checkLists = await getCheckLists(id, section);
        await inspection.addChecklists(
          pdf,
          SectionModel(inspectionId: id, sectionName: section),
          checkLists,
        );
      }

      inspectionPDF = await inspection.generatePDF(fileName, pdf);

      final res = await saveInspectionReport(
        associatedTo: id,
        file: inspectionPDF,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Inspection-$r report saved!');
          Routemaster.of(context).pop();
        },
      );
    }
    state = false;
  }

  //save Inspection report
  FutureEither<String> saveInspectionReport({
    required String associatedTo,
    required File file,
  }) async {
    try {
      state = true;
      final user = _ref.read(userProvider)!;

      int version = await _reportsRepository.getInspectionReportVersion(
        associatedTo,
        user.companyId,
      );

      ReportModel report = ReportModel(
        id: '',
        type: 'Inspection',
        version: version,
        title: 'Inspection Report',
        associatedTo: associatedTo,
        status: 'Open',
        fileUrl: '',
        fileType: file.path.split('.').last,
        fileName: file.path.split('/').last,
        createdBy: user.uid,
        createdAt: DateTime.now(),
      );

      if (file != null) {
        Uuid uuid = const Uuid();
        report = report.copyWith(
          id: uuid.v8(),
        );
        final filePath = '${user.companyId}/inspection-reports/$associatedTo';
        final res = await _storageRepository.storeFile(
          id: report.id,
          path: filePath,
          file: file,
          webFile: null,
        );

        res.fold(
          (l) {
            state = false;
            return left(Failure(message: l.message));
          },
          (r) {
            report = report.copyWith(
              fileUrl: r,
            );
          },
        );
      }

      final res = await _reportsRepository.saveInspectionReport(
        report,
        user.companyId,
      );
      state = false;
      return res.fold(
        (l) => left(Failure(message: l.message)),
        (r) => right(r),
      );
    } catch (e) {
      state = false;
      return left(Failure(message: e.toString()));
    }
  }

  Future<void> downloadReport(
      BuildContext context, String url, String fileName) async {
    state = true;
    final res = await _storageRepository.downloadFile(url, fileName);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, r),
    );
    state = false;
  }

  Future<void> deleteReport(
    BuildContext context,
    String url,
    String reportId,
    String fileType,
  ) async {
    state = true;
    final user = _ref.read(userProvider)!;

    final res = await _storageRepository.deleteFile(url: url);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        final res = await _reportsRepository.deleteReport(
          user.companyId,
          reportId,
          fileType,
        );
        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, r),
        );
      },
    );
    state = false;
  }

  //stream Inspection reports by company id
  Stream<List<ReportModel>> getInspectionReports() {
    final user = _ref.read(userProvider)!;
    return _reportsRepository.getInspectionReports(user.companyId);
  }

  //stream Inspection reports generated by user
  Stream<List<ReportModel>> getInspectionReportsCreatedByUser() {
    final user = _ref.read(userProvider)!;
    return _reportsRepository.getInspectionReportsCreatedByUser(
      user.companyId,
      user.uid,
    );
  }

  Future<List<CheckListModel>> getCheckLists(
    String inspectionId,
    String sectionName,
  ) async {
    final user = _ref.read(userProvider)!;
    return await _reportsRepository.getCheckLists(
      user.companyId,
      inspectionId,
      sectionName,
    );
  }
}
