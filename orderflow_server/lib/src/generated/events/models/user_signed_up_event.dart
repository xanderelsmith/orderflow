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

abstract class UserSignedUpEvent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UserSignedUpEvent._({
    required this.userId,
    required this.email,
    required this.signedUpAt,
  });

  factory UserSignedUpEvent({
    required String userId,
    required String email,
    required DateTime signedUpAt,
  }) = _UserSignedUpEventImpl;

  factory UserSignedUpEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSignedUpEvent(
      userId: jsonSerialization['userId'] as String,
      email: jsonSerialization['email'] as String,
      signedUpAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['signedUpAt'],
      ),
    );
  }

  String userId;

  String email;

  DateTime signedUpAt;

  /// Returns a shallow copy of this [UserSignedUpEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserSignedUpEvent copyWith({
    String? userId,
    String? email,
    DateTime? signedUpAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSignedUpEvent',
      'userId': userId,
      'email': email,
      'signedUpAt': signedUpAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserSignedUpEvent',
      'userId': userId,
      'email': email,
      'signedUpAt': signedUpAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UserSignedUpEventImpl extends UserSignedUpEvent {
  _UserSignedUpEventImpl({
    required String userId,
    required String email,
    required DateTime signedUpAt,
  }) : super._(
         userId: userId,
         email: email,
         signedUpAt: signedUpAt,
       );

  /// Returns a shallow copy of this [UserSignedUpEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserSignedUpEvent copyWith({
    String? userId,
    String? email,
    DateTime? signedUpAt,
  }) {
    return UserSignedUpEvent(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      signedUpAt: signedUpAt ?? this.signedUpAt,
    );
  }
}
