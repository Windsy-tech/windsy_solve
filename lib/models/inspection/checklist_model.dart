import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CheckListModel {
  String id;
  String inspectionId;
  String section;
  String system;
  String type;
  String checks;
  String notes;
  List<dynamic> actions;
  int risk;
  String createdBy;
  DateTime createdAt;
  String modifiedBy;
  DateTime modifiedAt;
  bool closed;

  CheckListModel({
    String? id,
    this.inspectionId = "",
    this.section = "",
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.system = "Exterior",
    this.type = "A.1",
    this.checks = "Visual Inspection",
    this.notes = "",
    this.actions = const [],
    this.risk = 0,
    this.closed = false,
    this.createdBy = "",
    this.modifiedBy = "",
  })  : createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now(),
        id = id ?? const Uuid().v1();

  CheckListModel copyWith({
    String? id,
    String? inspectionId,
    String? section,
    String? system,
    String? type,
    String? checks,
    String? notes,
    List<dynamic>? actions,
    int? risk,
    String? createdBy,
    DateTime? createdAt,
    String? modifiedBy,
    DateTime? modifiedAt,
    bool? closed,
  }) {
    return CheckListModel(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      section: section ?? this.section,
      system: system ?? this.system,
      type: type ?? this.type,
      checks: checks ?? this.checks,
      notes: notes ?? this.notes,
      actions: actions ?? this.actions,
      risk: risk ?? this.risk,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      closed: closed ?? this.closed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'inspectionId': inspectionId,
      'section': section,
      'system': system,
      'type': type,
      'checks': checks,
      'notes': notes,
      'actions': actions,
      'risk': risk,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'modifiedBy': modifiedBy,
      'modifiedAt': modifiedAt.millisecondsSinceEpoch,
      'closed': closed,
    };
  }

  factory CheckListModel.fromMap(Map<String, dynamic> map) {
    return CheckListModel(
      id: map['id'] as String,
      inspectionId: map['inspectionId'] as String,
      section: map['section'] as String,
      system: map['system'] as String,
      type: map['type'] as String,
      checks: map['checks'] as String,
      notes: map['notes'] as String,
      actions: List<dynamic>.from((map['actions'] as List<dynamic>)),
      risk: map['risk'] as int,
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      modifiedBy: map['modifiedBy'] as String,
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'] as int),
      closed: map['closed'] as bool,
    );
  }

  @override
  String toString() {
    return 'CheckListModel(id: $id, inspectionId: $inspectionId, section: $section, system: $system, type: $type, checks: $checks, notes: $notes, actions: $actions, risk: $risk, createdBy: $createdBy, createdAt: $createdAt, modifiedBy: $modifiedBy, modifiedAt: $modifiedAt, closed: $closed)';
  }

  @override
  bool operator ==(covariant CheckListModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.inspectionId == inspectionId &&
        other.section == section &&
        other.system == system &&
        other.type == type &&
        other.checks == checks &&
        other.notes == notes &&
        listEquals(other.actions, actions) &&
        other.risk == risk &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.modifiedBy == modifiedBy &&
        other.modifiedAt == modifiedAt &&
        other.closed == closed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        inspectionId.hashCode ^
        section.hashCode ^
        system.hashCode ^
        type.hashCode ^
        checks.hashCode ^
        notes.hashCode ^
        actions.hashCode ^
        risk.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        modifiedBy.hashCode ^
        modifiedAt.hashCode ^
        closed.hashCode;
  }
}
