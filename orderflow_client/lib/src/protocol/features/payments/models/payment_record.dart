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

abstract class PaymentRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PaymentRecord._({
    this.id,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory PaymentRecord({
    int? id,
    required int orderId,
    required double amount,
    required String status,
    required DateTime createdAt,
  }) = _PaymentRecordImpl;

  factory PaymentRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentRecord(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int orderId;

  double amount;

  String status;

  DateTime createdAt;

  /// Returns a shallow copy of this [PaymentRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PaymentRecord copyWith({
    int? id,
    int? orderId,
    double? amount,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentRecord',
      if (id != null) 'id': id,
      'orderId': orderId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentRecord',
      if (id != null) 'id': id,
      'orderId': orderId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentRecordImpl extends PaymentRecord {
  _PaymentRecordImpl({
    int? id,
    required int orderId,
    required double amount,
    required String status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         amount: amount,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PaymentRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PaymentRecord copyWith({
    Object? id = _Undefined,
    int? orderId,
    double? amount,
    String? status,
    DateTime? createdAt,
  }) {
    return PaymentRecord(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
