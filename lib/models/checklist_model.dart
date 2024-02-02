import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CheckListModel {
  String id;
  String system;
  String type;
  String checks;
  String notes;
  List<dynamic> remarks;
  int risk;
  DateTime createdAt;
  DateTime modifiedAt;
  bool closed;

  CheckListModel({
    String? id,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.system = "Exterior",
    this.type = "A.1",
    this.checks = "Visual Inspection",
    this.notes = "",
    this.remarks = const [],
    this.risk = 0,
    this.closed = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now(),
        id = id ?? const Uuid().v1();

  CheckListModel copyWith({
    String? id,
    String? system,
    String? type,
    String? checks,
    String? notes,
    List<dynamic>? remarks,
    int? risk,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? closed,
  }) {
    return CheckListModel(
      id: id ?? this.id,
      system: system ?? this.system,
      type: type ?? this.type,
      checks: checks ?? this.checks,
      notes: notes ?? this.notes,
      remarks: remarks ?? this.remarks,
      risk: risk ?? this.risk,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      closed: closed ?? this.closed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'system': system,
      'type': type,
      'checks': checks,
      'notes': notes,
      'remarks': remarks,
      'risk': risk,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'modifiedAt': modifiedAt.millisecondsSinceEpoch,
      'closed': closed,
    };
  }

  factory CheckListModel.fromMap(Map<String, dynamic> map) {
    return CheckListModel(
      id: map['id'] as String,
      system: map['system'] as String,
      type: map['type'] as String,
      checks: map['checks'] as String,
      notes: map['notes'] as String,
      remarks: List<dynamic>.from((map['remarks'] as List<dynamic>)),
      risk: map['risk'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'] as int),
      closed: map['closed'] as bool,
    );
  }

  @override
  String toString() {
    return 'CheckListModel(id: $id, system: $system, type: $type, checks: $checks, notes: $notes, remarks: $remarks, risk: $risk, createdAt: $createdAt, modifiedAt: $modifiedAt, closed: $closed)';
  }

  @override
  bool operator ==(covariant CheckListModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.system == system &&
        other.type == type &&
        other.checks == checks &&
        other.notes == notes &&
        listEquals(other.remarks, remarks) &&
        other.risk == risk &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt &&
        other.closed == closed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        system.hashCode ^
        type.hashCode ^
        checks.hashCode ^
        notes.hashCode ^
        remarks.hashCode ^
        risk.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode ^
        closed.hashCode;
  }
}