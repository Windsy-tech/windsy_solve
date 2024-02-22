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
  final List<String>? assignedTo;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;
  final String? closedBy;
  final DateTime? closedAt;
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
    this.assignedTo,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    this.closedBy,
    this.closedAt,
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
    List<String>? assignedTo,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    String? closedBy,
    DateTime? closedAt,
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
      updatedBy: updatedBy ?? this.updatedBy,
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
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'closedBy': closedBy,
      'closedAt': closedAt?.millisecondsSinceEpoch,
      'closedReason': closedReason,
    };
  }

  factory NCModel.fromMap(Map<String, dynamic> map) {
    try {
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
        assignedTo: List<String>.from(map['assignedTo']),
        createdBy: map['createdBy'] ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        updatedBy: map['updatedBy'] ?? '',
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
        closedBy: map['closedBy'] ?? '',
        closedAt: DateTime.fromMillisecondsSinceEpoch(map['closedAt']),
        closedReason: map['closedReason'] ?? '',
      );
    } catch (e) {
      //print("Error creating NCModel: $e");
      rethrow; // Rethrow the exception to propagate it further
    }
  }

  @override
  String toString() {
    return 'NCModel(id: $id, title: $title, problemDescription: $problemDescription, status: $status, severity: $severity, category: $category, windFarm: $windFarm, turbineNo: $turbineNo, platform: $platform, oem: $oem, createdBy: $createdBy, assignedTo: $assignedTo, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt, closedAt: $closedAt, closedBy: $closedBy, closedReason: $closedReason)';
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
        listEquals(other.assignedTo, assignedTo) &&
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
        windFarm.hashCode ^
        turbineNo.hashCode ^
        platform.hashCode ^
        oem.hashCode ^
        assignedTo.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedBy.hashCode ^
        updatedAt.hashCode ^
        closedBy.hashCode ^
        closedAt.hashCode ^
        closedReason.hashCode;
  }
}
