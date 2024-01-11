import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String companyName;
  final String companyId;
  final String email;
  final String countryCode;
  final int phoneNumber;
  final String photoUrl;
  final String role;
  final List<String> expertise;
  final String lastLoginDate;
  final String lastLoginTime;
  final bool isActive;
  final bool isBlocked;
  UserModel({
    required this.uid,
    required this.displayName,
    required this.companyName,
    required this.companyId,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.photoUrl,
    required this.role,
    required this.expertise,
    required this.lastLoginDate,
    required this.lastLoginTime,
    required this.isActive,
    required this.isBlocked,
  });

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? companyName,
    String? companyId,
    String? email,
    String? countryCode,
    int? phoneNumber,
    String? photoUrl,
    String? role,
    List<String>? expertise,
    String? lastLoginDate,
    String? lastLoginTime,
    bool? isActive,
    bool? isBlocked,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      companyName: companyName ?? this.companyName,
      companyId: companyId ?? this.companyId,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      expertise: expertise ?? this.expertise,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'companyName': companyName,
      'companyId': companyId,
      'email': email,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role,
      'expertise': expertise,
      'lastLoginDate': lastLoginDate,
      'lastLoginTime': lastLoginTime,
      'isActive': isActive,
      'isBlocked': isBlocked,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      companyName: map['companyName'] ?? '',
      companyId: map['companyId'] ?? '',
      email: map['email'] ?? '',
      countryCode: map['countryCode'] ?? '',
      phoneNumber: map['phoneNumber'] ?? 0,
      photoUrl: map['photoUrl'] ?? '',
      role: map['role'] ?? '',
      expertise: List<String>.from(map['expertise']),
      lastLoginDate: map['lastLoginDate'] ?? '',
      lastLoginTime: map['lastLoginTime'] ?? '',
      isActive: map['isActive'] ?? false,
      isBlocked: map['isBlocked'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, companyName: $companyName, companyId: $companyId, email: $email, countryCode: $countryCode, phoneNumber: $phoneNumber, photoUrl: $photoUrl, role: $role, expertise: $expertise, lastLoginDate: $lastLoginDate, lastLoginTime: $lastLoginTime, isActive: $isActive, isBlocked: $isBlocked)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.displayName == displayName &&
        other.companyName == companyName &&
        other.companyId == companyId &&
        other.email == email &&
        other.countryCode == countryCode &&
        other.phoneNumber == phoneNumber &&
        other.photoUrl == photoUrl &&
        other.role == role &&
        listEquals(other.expertise, expertise) &&
        other.lastLoginDate == lastLoginDate &&
        other.lastLoginTime == lastLoginTime &&
        other.isActive == isActive &&
        other.isBlocked == isBlocked;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        displayName.hashCode ^
        companyName.hashCode ^
        companyId.hashCode ^
        email.hashCode ^
        countryCode.hashCode ^
        phoneNumber.hashCode ^
        photoUrl.hashCode ^
        role.hashCode ^
        expertise.hashCode ^
        lastLoginDate.hashCode ^
        lastLoginTime.hashCode ^
        isActive.hashCode ^
        isBlocked.hashCode;
  }
}
