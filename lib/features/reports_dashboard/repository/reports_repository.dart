import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:windsy_solve/models/reports/reports_model.dart';

class ReportsRepository {
  final FirebaseFirestore _firestore;

  ReportsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _companies => _firestore.collection('companies');

  //Get NC reports
  Stream<List<ReportModel>> getNCReports(String companyId) {
    return _companies
        .doc(companyId)
        .collection('nc-reports')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return ReportModel.fromMap(e.data());
      }).toList();
    });
  }

  //Get Inspection reports
  Stream<List<ReportModel>> getInspectionReports(String companyId) {
    return _companies
        .doc(companyId)
        .collection('inspections-reports')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return ReportModel.fromMap(e.data());
      }).toList();
    });
  }
}
