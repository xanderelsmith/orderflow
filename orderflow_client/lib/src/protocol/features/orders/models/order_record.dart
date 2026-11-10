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

abstract class OrderRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OrderRecord._({
    this.id,
    required this.userId,
    required this.itemCount,
    required this.totalPrice,
  });

  factory OrderRecord({
    int? id,
    required String userId,
    required int itemCount,
    required double totalPrice,
  }) = _OrderRecordImpl;

  factory OrderRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      itemCount: jsonSerialization['itemCount'] as int,
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  int itemCount;

  double totalPrice;

  /// Returns a shallow copy of this [OrderRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OrderRecord copyWith({
    int? id,
    String? userId,
    int? itemCount,
    double? totalPrice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderRecordImpl extends OrderRecord {
  _OrderRecordImpl({
    int? id,
    required String userId,
    required int itemCount,
    required double totalPrice,
  }) : super._(
         id: id,
         userId: userId,
         itemCount: itemCount,
         totalPrice: totalPrice,
       );

  /// Returns a shallow copy of this [OrderRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OrderRecord copyWith({
    Object? id = _Undefined,
    String? userId,
    int? itemCount,
    double? totalPrice,
  }) {
    return OrderRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      itemCount: itemCount ?? this.itemCount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
