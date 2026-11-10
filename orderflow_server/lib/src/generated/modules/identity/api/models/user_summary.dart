/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class UserSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UserSummary._({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.isActive,
  });

  factory UserSummary({
    required int userId,
    required String fullName,
    required String email,
    required bool isActive,
  }) = _UserSummaryImpl;

  factory UserSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSummary(
      userId: jsonSerialization['userId'] as int,
      fullName: jsonSerialization['fullName'] as String,
      email: jsonSerialization['email'] as String,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  int userId;

  String fullName;

  String email;

  bool isActive;

  /// Returns a shallow copy of this [UserSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserSummary copyWith({
    int? userId,
    String? fullName,
    String? email,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSummary',
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserSummary',
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UserSummaryImpl extends UserSummary {
  _UserSummaryImpl({
    required int userId,
    required String fullName,
    required String email,
    required bool isActive,
  }) : super._(
         userId: userId,
         fullName: fullName,
         email: email,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [UserSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserSummary copyWith({
    int? userId,
    String? fullName,
    String? email,
    bool? isActive,
  }) {
    return UserSummary(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
    );
  }
}
