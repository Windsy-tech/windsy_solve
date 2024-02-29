//Reports Model

class ReportModel {
  final String id;
  final String title;
  final int version;
  final String type;
  final String associatedTo;
  final String createdBy;
  final DateTime createdAt;
  final String status;
  final String fileUrl;
  final String fileType;
  final String fileName;

  ReportModel({
    required this.id,
    required this.title,
    required this.version,
    required this.type,
    required this.associatedTo,
    required this.createdBy,
    required this.createdAt,
    required this.status,
    required this.fileUrl,
    required this.fileType,
    required this.fileName,
  });

  ReportModel copyWith({
    String? id,
    String? title,
    int? version,
    String? type,
    String? associatedTo,
    String? createdBy,
    DateTime? createdAt,
    String? status,
    String? fileUrl,
    String? fileType,
    String? fileName,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      version: version ?? this.version,
      type: type ?? this.type,
      associatedTo: associatedTo ?? this.associatedTo,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      fileName: fileName ?? this.fileName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'version': version,
      'type': type,
      'associatedTo': associatedTo,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'fileName': fileName,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as String,
      title: map['title'] as String,
      version: map['version'] as int,
      type: map['type'] as String,
      associatedTo: map['associatedTo'] as String,
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      status: map['status'] as String,
      fileUrl: map['fileUrl'] as String,
      fileType: map['fileType'] as String,
      fileName: map['fileName'] as String,
    );
  }

  @override
  String toString() {
    return 'ReportModel(id: $id, title: $title, version: $version, type: $type, associatedTo: $associatedTo, createdBy: $createdBy, createdAt: $createdAt, status: $status, fileUrl: $fileUrl, fileType: $fileType, fileName: $fileName)';
  }

  @override
  bool operator ==(covariant ReportModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.version == version &&
        other.type == type &&
        other.associatedTo == associatedTo &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.status == status &&
        other.fileUrl == fileUrl &&
        other.fileType == fileType &&
        other.fileName == fileName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        version.hashCode ^
        type.hashCode ^
        associatedTo.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        fileUrl.hashCode ^
        fileType.hashCode ^
        fileName.hashCode;
  }
}
