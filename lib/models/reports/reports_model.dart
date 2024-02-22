import 'dart:convert';

class ReportModel {
  final String id;
  final String title;
  final String associatedTo;
  final String createdBy;
  final DateTime createdAt;
  final String status;
  final String fileLink;
  final String fileType;
  final String fileName;

  ReportModel({
    required this.id,
    required this.title,
    required this.associatedTo,
    required this.createdBy,
    required this.createdAt,
    required this.status,
    required this.fileLink,
    required this.fileType,
    required this.fileName,
  });

  ReportModel copyWith({
    String? id,
    String? title,
    String? associatedTo,
    String? createdBy,
    DateTime? createdAt,
    String? status,
    String? fileLink,
    String? fileType,
    String? fileName,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      associatedTo: associatedTo ?? this.associatedTo,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      fileLink: fileLink ?? this.fileLink,
      fileType: fileType ?? this.fileType,
      fileName: fileName ?? this.fileName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'associatedTo': associatedTo,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status,
      'fileLink': fileLink,
      'fileType': fileType,
      'fileName': fileName,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as String,
      title: map['title'] as String,
      associatedTo: map['associatedTo'] as String,
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      status: map['status'] as String,
      fileLink: map['fileLink'] as String,
      fileType: map['fileType'] as String,
      fileName: map['fileName'] as String,
    );
  }

  @override
  String toString() {
    return 'ReportModel(id: $id, title: $title, associatedTo: $associatedTo, createdBy: $createdBy, createdAt: $createdAt, status: $status, fileLink: $fileLink, fileType: $fileType, fileName: $fileName)';
  }

  @override
  bool operator ==(covariant ReportModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.associatedTo == associatedTo &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.status == status &&
        other.fileLink == fileLink &&
        other.fileType == fileType &&
        other.fileName == fileName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        associatedTo.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        fileLink.hashCode ^
        fileType.hashCode ^
        fileName.hashCode;
  }
}
