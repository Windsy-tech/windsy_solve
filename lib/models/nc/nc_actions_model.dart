import 'package:flutter/foundation.dart';

class NCActionsModel {
  final String id;
  final String action;
  final String description;
  final String dueDate;
  final String status;
  final String createdBy;
  final String createdAt;
  final String completedBy;
  final String completedAt;
  final List<String> assignedTo;
  final List<Map<String, dynamic>> comments;

  NCActionsModel({
    required this.id,
    required this.action,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.completedBy,
    required this.completedAt,
    required this.assignedTo,
    required this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'description': description,
      'dueDate': dueDate,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'completedBy': completedBy,
      'completedAt': completedAt,
      'assignedTo': assignedTo,
      'comments': comments,
    };
  }

  factory NCActionsModel.fromMap(Map<String, dynamic> map) {
    return NCActionsModel(
      id: map['id'],
      action: map['action'],
      description: map['description'],
      dueDate: map['dueDate'],
      status: map['status'],
      createdBy: map['createdBy'],
      createdAt: map['createdAt'],
      completedBy: map['completedBy'],
      completedAt: map['completedAt'],
      assignedTo: List<String>.from(map['assignedTo']),
      comments: List<Map<String, dynamic>>.from(map['comments']),
    );
  }

  NCActionsModel copyWith({
    String? id,
    String? action,
    String? description,
    String? dueDate,
    String? status,
    String? createdBy,
    String? createdAt,
    String? completedBy,
    String? completedAt,
    List<String>? assignedTo,
    List<Map<String, dynamic>>? comments,
  }) {
    return NCActionsModel(
      id: id ?? this.id,
      action: action ?? this.action,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      completedBy: completedBy ?? this.completedBy,
      completedAt: completedAt ?? this.completedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      comments: comments ?? this.comments,
    );
  }

  @override
  String toString() {
    return 'NCActionsModel(id: $id, action: $action, description: $description, dueDate: $dueDate, status: $status, createdBy: $createdBy, createdAt: $createdAt, completedBy: $completedBy, completedAt: $completedAt, assignedTo: $assignedTo, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NCActionsModel &&
        other.id == id &&
        other.action == action &&
        other.description == description &&
        other.dueDate == dueDate &&
        other.status == status &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.completedBy == completedBy &&
        other.completedAt == completedAt &&
        listEquals(other.assignedTo, assignedTo) &&
        listEquals(other.comments, comments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        action.hashCode ^
        description.hashCode ^
        dueDate.hashCode ^
        status.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        completedBy.hashCode ^
        completedAt.hashCode ^
        assignedTo.hashCode ^
        comments.hashCode;
  }
}
