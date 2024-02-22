import 'package:flutter/foundation.dart';

class InspectionModel {
  final String id;
  final String title;
  final String problemDescription;
  final String status;
  final int severity;
  final String category;
  final String customer;
  final String externalAuditor;
  final String supplier;
  final String windFarm;
  final String turbineNo;
  final String? platform;
  final String? oem;
  final List<String>? members;
  final List<String>? assignedTo;
  final List<String>? sections;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;
  final String? closedBy;
  final DateTime? closedAt;
  final String? closedReason;

  InspectionModel({
    required this.id,
    required this.title,
    required this.problemDescription,
    required this.status,
    required this.severity,
    required this.category,
    required this.customer,
    required this.externalAuditor,
    required this.supplier,
    required this.windFarm,
    required this.turbineNo,
    this.platform,
    this.oem,
    this.members,
    this.assignedTo,
    this.sections,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    this.closedBy,
    this.closedAt,
    this.closedReason,
  });

  InspectionModel copyWith({
    String? id,
    String? title,
    String? problemDescription,
    String? status,
    int? severity,
    String? category,
    String? customer,
    String? externalAuditor,
    String? supplier,
    String? windFarm,
    String? turbineNo,
    String? platform,
    String? oem,
    List<String>? members,
    List<String>? assignedTo,
    List<String>? sections,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    String? closedBy,
    DateTime? closedAt,
    String? closedReason,
  }) {
    return InspectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      problemDescription: problemDescription ?? this.problemDescription,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      category: category ?? this.category,
      customer: customer ?? this.customer,
      externalAuditor: externalAuditor ?? this.externalAuditor,
      supplier: supplier ?? this.supplier,
      windFarm: windFarm ?? this.windFarm,
      turbineNo: turbineNo ?? this.turbineNo,
      platform: platform ?? this.platform,
      oem: oem ?? this.oem,
      members: members ?? this.members,
      assignedTo: assignedTo ?? this.assignedTo,
      sections: sections ?? this.sections,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      closedBy: closedBy ?? this.closedBy,
      closedAt: closedAt ?? this.closedAt,
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
      'customer': customer,
      'externalAuditor': externalAuditor,
      'supplier': supplier,
      'windFarm': windFarm,
      'turbineNo': turbineNo,
      'platform': platform,
      'oem': oem,
      'members': members,
      'assignedTo': assignedTo,
      'sections': sections,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'closedBy': closedBy,
      'closedAt': closedAt?.millisecondsSinceEpoch,
      'closedReason': closedReason,
    };
  }

  factory InspectionModel.fromMap(Map<String, dynamic> map) {
    return InspectionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      problemDescription: map['problemDescription'] ?? '',
      status: map['status'] ?? '',
      severity: map['severity'] ?? 0,
      category: map['category'] ?? '',
      customer: map['customer'] ?? '',
      externalAuditor: map['externalAuditor'] ?? '',
      supplier: map['supplier'] ?? '',
      windFarm: map['windFarm'] ?? '',
      turbineNo: map['turbineNo'] ?? '',
      platform: map['platform'] ?? '',
      oem: map['oem'] ?? '',
      members: List<String>.from((map['members'])),
      assignedTo: List<String>.from((map['assignedTo'])),
      sections: List<String>.from((map['sections'])),
      createdBy: map['createdBy'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedBy: map['updatedBy'] ?? '',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      closedBy: map['closedBy'] ?? '',
      closedAt: DateTime.fromMillisecondsSinceEpoch(map['closedAt']),
      closedReason: map['closedReason'] ?? '',
    );
  }

  @override
  String toString() {
    return 'InspectionModel(id: $id, title: $title, problemDescription: $problemDescription, status: $status, severity: $severity, category: $category, customer: $customer, externalAuditor: $externalAuditor, supplier: $supplier, windFarm: $windFarm, turbineNo: $turbineNo, platform: $platform, oem: $oem, members: $members, assignedTo: $assignedTo, sections: $sections , createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt, closedBy: $closedBy, closedAt: $closedAt, closedReason: $closedReason)';
  }

  @override
  bool operator ==(covariant InspectionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.problemDescription == problemDescription &&
        other.status == status &&
        other.severity == severity &&
        other.category == category &&
        other.customer == customer &&
        other.externalAuditor == externalAuditor &&
        other.supplier == supplier &&
        other.windFarm == windFarm &&
        other.turbineNo == turbineNo &&
        other.platform == platform &&
        other.oem == oem &&
        listEquals(other.members, members) &&
        listEquals(other.assignedTo, assignedTo) &&
        listEquals(other.sections, sections) &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedBy == updatedBy &&
        other.updatedAt == updatedAt &&
        other.closedBy == closedBy &&
        other.closedAt == closedAt &&
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
        customer.hashCode ^
        externalAuditor.hashCode ^
        supplier.hashCode ^
        windFarm.hashCode ^
        turbineNo.hashCode ^
        platform.hashCode ^
        oem.hashCode ^
        members.hashCode ^
        assignedTo.hashCode ^
        sections.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedBy.hashCode ^
        updatedAt.hashCode ^
        closedBy.hashCode ^
        closedAt.hashCode ^
        closedReason.hashCode;
  }
}
