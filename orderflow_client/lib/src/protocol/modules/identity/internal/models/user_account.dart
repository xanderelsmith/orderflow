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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class UserAccount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserAccount._({
    this.id,
    required this.email,
    required this.hashedPassword,
    required this.firstName,
    required this.lastName,
    required this.isActive,
  });

  factory UserAccount({
    int? id,
    required String email,
    required String hashedPassword,
    required String firstName,
    required String lastName,
    required bool isActive,
  }) = _UserAccountImpl;

  factory UserAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserAccount(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      hashedPassword: jsonSerialization['hashedPassword'] as String,
      firstName: jsonSerialization['firstName'] as String,
      lastName: jsonSerialization['lastName'] as String,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String email;

  String hashedPassword;

  String firstName;

  String lastName;

  bool isActive;

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserAccount copyWith({
    int? id,
    String? email,
    String? hashedPassword,
    String? firstName,
    String? lastName,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAccount',
      if (id != null) 'id': id,
      'email': email,
      'hashedPassword': hashedPassword,
      'firstName': firstName,
      'lastName': lastName,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserAccount',
      if (id != null) 'id': id,
      'email': email,
      'hashedPassword': hashedPassword,
      'firstName': firstName,
      'lastName': lastName,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserAccountImpl extends UserAccount {
  _UserAccountImpl({
    int? id,
    required String email,
    required String hashedPassword,
    required String firstName,
    required String lastName,
    required bool isActive,
  }) : super._(
         id: id,
         email: email,
         hashedPassword: hashedPassword,
         firstName: firstName,
         lastName: lastName,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserAccount copyWith({
    Object? id = _Undefined,
    String? email,
    String? hashedPassword,
    String? firstName,
    String? lastName,
    bool? isActive,
  }) {
    return UserAccount(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isActive: isActive ?? this.isActive,
    );
  }
}
