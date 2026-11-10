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

abstract class CustomerOrder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerOrder._({
    this.id,
    required this.userId,
    required this.total,
    required this.createdAt,
  });

  factory CustomerOrder({
    int? id,
    required String userId,
    required double total,
    required DateTime createdAt,
  }) = _CustomerOrderImpl;

  factory CustomerOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerOrder(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      total: (jsonSerialization['total'] as num).toDouble(),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  double total;

  DateTime createdAt;

  /// Returns a shallow copy of this [CustomerOrder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerOrder copyWith({
    int? id,
    String? userId,
    double? total,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerOrder',
      if (id != null) 'id': id,
      'userId': userId,
      'total': total,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerOrder',
      if (id != null) 'id': id,
      'userId': userId,
      'total': total,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerOrderImpl extends CustomerOrder {
  _CustomerOrderImpl({
    int? id,
    required String userId,
    required double total,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         total: total,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CustomerOrder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerOrder copyWith({
    Object? id = _Undefined,
    String? userId,
    double? total,
    DateTime? createdAt,
  }) {
    return CustomerOrder(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
