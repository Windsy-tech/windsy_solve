// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class WindFarmModel {
  final String? windFarm;
  final String? turbineNo;
  final String? platform;
  final String? oem;
  final String? country;
  final int? activeNc;
  final int? closedNc;
  final DateTime? commissionedDate;
  final List<String>? reportedNc;
  WindFarmModel({
    this.windFarm,
    this.turbineNo,
    this.platform,
    this.oem,
    this.country,
    this.activeNc,
    this.closedNc,
    this.commissionedDate,
    this.reportedNc,
  });

  WindFarmModel copyWith({
    String? windFarm,
    String? turbineNo,
    String? platform,
    String? oem,
    String? country,
    int? activeNc,
    int? closedNc,
    DateTime? commissionedDate,
    List<String>? reportedNc,
  }) {
    return WindFarmModel(
      windFarm: windFarm ?? this.windFarm,
      turbineNo: turbineNo ?? this.turbineNo,
      platform: platform ?? this.platform,
      oem: oem ?? this.oem,
      country: country ?? this.country,
      activeNc: activeNc ?? this.activeNc,
      closedNc: closedNc ?? this.closedNc,
      commissionedDate: commissionedDate ?? this.commissionedDate,
      reportedNc: reportedNc ?? this.reportedNc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'windFarm': windFarm,
      'turbineNo': turbineNo,
      'platform': platform,
      'oem': oem,
      'country': country,
      'activeNc': activeNc,
      'closedNc': closedNc,
      'commissionedDate': commissionedDate?.millisecondsSinceEpoch,
      'reportedNc': reportedNc,
    };
  }

  factory WindFarmModel.fromMap(Map<String, dynamic> map) {
    return WindFarmModel(
      windFarm: map['windFarm'] != null ? map['windFarm'] ?? '' : null,
      turbineNo: map['turbineNo'] != null ? map['turbineNo'] ?? '' : null,
      platform: map['platform'] != null ? map['platform'] ?? '' : null,
      oem: map['oem'] != null ? map['oem'] ?? '' : null,
      country: map['country'] != null ? map['country'] ?? '' : null,
      activeNc: map['activeNc'] != null ? map['activeNc'] ?? '' : null,
      closedNc: map['closedNc'] != null ? map['closedNc'] ?? '' : null,
      commissionedDate: map['commissionedDate'] != null
          ? (map['commissionedDate'] as Timestamp).toDate()
          : null,
      reportedNc: map['reportedNc'] != null
          ? List<String>.from((map['reportedNc']))
          : null,
    );
  }

  @override
  String toString() {
    return 'WindFarmModel(windFarm: $windFarm, turbineNo: $turbineNo, platform: $platform, oem: $oem, country: $country, activeNc: $activeNc, closedNc: $closedNc, commissionedDate: $commissionedDate, reportedNc: $reportedNc)';
  }

  @override
  bool operator ==(covariant WindFarmModel other) {
    if (identical(this, other)) return true;

    return other.windFarm == windFarm &&
        other.turbineNo == turbineNo &&
        other.platform == platform &&
        other.oem == oem &&
        other.country == country &&
        other.activeNc == activeNc &&
        other.closedNc == closedNc &&
        other.commissionedDate == commissionedDate &&
        listEquals(other.reportedNc, reportedNc);
  }

  @override
  int get hashCode {
    return windFarm.hashCode ^
        turbineNo.hashCode ^
        platform.hashCode ^
        oem.hashCode ^
        country.hashCode ^
        activeNc.hashCode ^
        closedNc.hashCode ^
        commissionedDate.hashCode ^
        reportedNc.hashCode;
  }
}
