// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

//Non-Conformity Model
class NCModel {
  final String id;
  final String title;
  final String problemDescription;
  final String status;
  final int severity;
  final String category;
  final String windFarm;
  final String turbineNo;
  final String? platform;
  final String? oem;
  final String createdBy;
  final List<String>? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime closedAt;
  final String? closedBy;
  final String? closedReason;

  NCModel({
    required this.id,
    required this.title,
    required this.problemDescription,
    required this.status,
    required this.severity,
    required this.category,
    required this.windFarm,
    required this.turbineNo,
    this.platform,
    this.oem,
    required this.createdBy,
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    required this.closedAt,
    this.closedBy,
    this.closedReason,
  });

  NCModel copyWith({
    String? id,
    String? title,
    String? problemDescription,
    String? status,
    int? severity,
    String? category,
    String? windFarm,
    String? turbineNo,
    String? platform,
    String? oem,
    String? createdBy,
    List<String>? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    String? closedBy,
    String? closedReason,
  }) {
    return NCModel(
      id: id ?? this.id,
      title: title ?? this.title,
      problemDescription: problemDescription ?? this.problemDescription,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      category: category ?? this.category,
      windFarm: windFarm ?? this.windFarm,
      turbineNo: turbineNo ?? this.turbineNo,
      platform: platform ?? this.platform,
      oem: oem ?? this.oem,
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
      closedBy: closedBy ?? this.closedBy,
      closedReason: closedReason ?? this.closedReason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'problemDescription': problemDescription,
      'status': status,
      'severity': severity,
      'category': category,
      'windFarm': windFarm,
      'turbineNo': turbineNo,
      'platform': platform,
      'oem': oem,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'closedAt': closedAt.millisecondsSinceEpoch,
      'closedBy': closedBy,
      'closedReason': closedReason,
    };
  }

  factory NCModel.fromMap(Map<String, dynamic> map) {
    return NCModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      problemDescription: map['problemDescription'] ?? '',
      status: map['status'] ?? '',
      severity: map['severity'] ?? 0,
      category: map['category'] ?? '',
      windFarm: map['windFarm'] ?? '',
      turbineNo: map['turbineNo'] ?? '',
      platform: map['platform'] ?? '',
      oem: map['oem'] ?? '',
      createdBy: map['createdBy'] ?? '',
      assignedTo: List<String>.from((map['assignedTo'])),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      closedAt: DateTime.fromMillisecondsSinceEpoch(map['closedAt']),
      closedBy: map['closedBy'] ?? '',
      closedReason: map['closedReason'] ?? '',
    );
  }

  @override
  String toString() {
    return 'NCModel(id: $id, title: $title, problemDescription: $problemDescription, status: $status, severity: $severity, category: $category, windFarm: $windFarm, turbineNo: $turbineNo, platform: $platform, oem: $oem, createdBy: $createdBy, assignedTo: $assignedTo, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt, closedBy: $closedBy, closedReason: $closedReason)';
  }

  @override
  bool operator ==(covariant NCModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.problemDescription == problemDescription &&
        other.status == status &&
        other.severity == severity &&
        other.category == category &&
        other.windFarm == windFarm &&
        other.turbineNo == turbineNo &&
        other.platform == platform &&
        other.oem == oem &&
        other.createdBy == createdBy &&
        listEquals(other.assignedTo, assignedTo) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.closedAt == closedAt &&
        other.closedBy == closedBy &&
        other.closedReason == closedReason;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        problemDescription.hashCode ^
        status.hashCode ^
        severity.hashCode ^
        category.hashCode ^
        windFarm.hashCode ^
        turbineNo.hashCode ^
        platform.hashCode ^
        oem.hashCode ^
        createdBy.hashCode ^
        assignedTo.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        closedAt.hashCode ^
        closedBy.hashCode ^
        closedReason.hashCode;
  }
}
