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

abstract class LedgerEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LedgerEntry._({
    this.id,
    required this.userId,
    required this.amount,
    required this.createdAt,
  });

  factory LedgerEntry({
    int? id,
    required int userId,
    required double amount,
    required DateTime createdAt,
  }) = _LedgerEntryImpl;

  factory LedgerEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LedgerEntry(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  double amount;

  DateTime createdAt;

  /// Returns a shallow copy of this [LedgerEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LedgerEntry copyWith({
    int? id,
    int? userId,
    double? amount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LedgerEntry',
      if (id != null) 'id': id,
      'userId': userId,
      'amount': amount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LedgerEntry',
      if (id != null) 'id': id,
      'userId': userId,
      'amount': amount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LedgerEntryImpl extends LedgerEntry {
  _LedgerEntryImpl({
    int? id,
    required int userId,
    required double amount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         amount: amount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LedgerEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LedgerEntry copyWith({
    Object? id = _Undefined,
    int? userId,
    double? amount,
    DateTime? createdAt,
  }) {
    return LedgerEntry(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
