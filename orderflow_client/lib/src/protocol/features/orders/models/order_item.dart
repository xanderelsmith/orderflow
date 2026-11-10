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

abstract class OrderItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OrderItem._({
    this.id,
    required this.orderId,
    required this.sku,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem({
    int? id,
    required int orderId,
    required String sku,
    required int quantity,
    required double unitPrice,
  }) = _OrderItemImpl;

  factory OrderItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderItem(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      sku: jsonSerialization['sku'] as String,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int orderId;

  String sku;

  int quantity;

  double unitPrice;

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OrderItem copyWith({
    int? id,
    int? orderId,
    String? sku,
    int? quantity,
    double? unitPrice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderItem',
      if (id != null) 'id': id,
      'orderId': orderId,
      'sku': sku,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderItem',
      if (id != null) 'id': id,
      'orderId': orderId,
      'sku': sku,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderItemImpl extends OrderItem {
  _OrderItemImpl({
    int? id,
    required int orderId,
    required String sku,
    required int quantity,
    required double unitPrice,
  }) : super._(
         id: id,
         orderId: orderId,
         sku: sku,
         quantity: quantity,
         unitPrice: unitPrice,
       );

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OrderItem copyWith({
    Object? id = _Undefined,
    int? orderId,
    String? sku,
    int? quantity,
    double? unitPrice,
  }) {
    return OrderItem(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
