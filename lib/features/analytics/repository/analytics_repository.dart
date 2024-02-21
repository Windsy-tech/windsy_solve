import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(firestore: ref.watch(firestoreProvider));
});

class AnalyticsRepository {
  final FirebaseFirestore _firestore;

  AnalyticsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _companies => _firestore.collection('companies');

  //Get NC count by month
  Stream<Map<int, int>> getNCCountByMonth(String companyId, int year) {
    int startDate = DateTime(year, 1, 1).millisecondsSinceEpoch;
    int endDate = DateTime(year, 12, 31).millisecondsSinceEpoch;
    return _companies
        .doc(companyId)
        .collection('ncs')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: startDate,
          isLessThanOrEqualTo: endDate,
        )
        .snapshots()
        .map((event) {
      final Map<int, int> map = {};
      for (int i = 1; i <= 12; i++) {
        map[i] = 0;
      }
      for (var element in event.docs) {
        int createdAt = (element.data())['createdAt'];
        DateTime date = DateTime.fromMillisecondsSinceEpoch(createdAt);

        map[date.month] = map[date.month]! + 1;
      }
      return map;
    });
  }

  //Get NC count by status
  Stream<Map<String, int>> getNCCountByStatus(String companyId, int year) {
    int startDate = DateTime(year, 1, 1).millisecondsSinceEpoch;
    int endDate = DateTime(year, 12, 31).millisecondsSinceEpoch;
    return _companies
        .doc(companyId)
        .collection('ncs')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: startDate,
          isLessThanOrEqualTo: endDate,
        )
        .snapshots()
        .map((event) {
      final Map<String, int> map = {
        'Open': 0,
        'Closed': 0,
      };
      for (var element in event.docs) {
        String status = (element.data())['status'];
        map[status] = map[status]! + 1;
      }
      return map;
    });
  }
}
