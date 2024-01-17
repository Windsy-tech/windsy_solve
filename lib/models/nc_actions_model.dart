import 'package:flutter/foundation.dart';

class NCActionsModel {
  final String id;
  final String title;
  final String problemDescription;
  final String dueDate;
  final String status;
  final List<String> assignedTo;
  final List<Map<String, dynamic>> comments;

  NCActionsModel({
    required this.id,
    required this.title,
    required this.problemDescription,
    required this.dueDate,
    required this.status,
    required this.assignedTo,
    required this.comments,
  });

  NCActionsModel copyWith({
    String? id,
    String? title,
    String? problemDescription,
    String? dueDate,
    String? status,
    List<String>? assignedTo,
    List<Map<String, dynamic>>? comments,
  }) {
    return NCActionsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      problemDescription: problemDescription ?? this.problemDescription,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'problemDescription': problemDescription,
      'dueDate': dueDate,
      'status': status,
      'assignedTo': assignedTo,
      'comments': comments,
    };
  }

  factory NCActionsModel.fromMap(Map<String, dynamic> map) {
    return NCActionsModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      problemDescription: map['problemDescription'] ?? '',
      dueDate: map['dueDate'] ?? '',
      status: map['status'] ?? '',
      assignedTo: List<String>.from((map['assignedTo'])),
      comments: List<Map<String, dynamic>>.from(
        (map['comments']).map<Map<String, dynamic>>(
          (x) => x,
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'NCActionsModel(id: $id, title: $title, problemDescription: $problemDescription, dueDate: $dueDate, status: $status, assignedTo: $assignedTo, comments: $comments)';
  }

  @override
  bool operator ==(covariant NCActionsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.problemDescription == problemDescription &&
        other.dueDate == dueDate &&
        other.status == status &&
        listEquals(other.assignedTo, assignedTo) &&
        listEquals(other.comments, comments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        problemDescription.hashCode ^
        dueDate.hashCode ^
        status.hashCode ^
        assignedTo.hashCode ^
        comments.hashCode;
  }
}
