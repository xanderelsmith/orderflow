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

abstract class OrderCreatedEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OrderCreatedEvent._({
    required this.orderId,
    required this.userEmail,
    required this.totalAmount,
  });

  factory OrderCreatedEvent({
    required int orderId,
    required String userEmail,
    required double totalAmount,
  }) = _OrderCreatedEventImpl;

  factory OrderCreatedEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderCreatedEvent(
      orderId: jsonSerialization['orderId'] as int,
      userEmail: jsonSerialization['userEmail'] as String,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
    );
  }

  int orderId;

  String userEmail;

  double totalAmount;

  /// Returns a shallow copy of this [OrderCreatedEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OrderCreatedEvent copyWith({
    int? orderId,
    String? userEmail,
    double? totalAmount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderCreatedEvent',
      'orderId': orderId,
      'userEmail': userEmail,
      'totalAmount': totalAmount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderCreatedEvent',
      'orderId': orderId,
      'userEmail': userEmail,
      'totalAmount': totalAmount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _OrderCreatedEventImpl extends OrderCreatedEvent {
  _OrderCreatedEventImpl({
    required int orderId,
    required String userEmail,
    required double totalAmount,
  }) : super._(
         orderId: orderId,
         userEmail: userEmail,
         totalAmount: totalAmount,
       );

  /// Returns a shallow copy of this [OrderCreatedEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OrderCreatedEvent copyWith({
    int? orderId,
    String? userEmail,
    double? totalAmount,
  }) {
    return OrderCreatedEvent(
      orderId: orderId ?? this.orderId,
      userEmail: userEmail ?? this.userEmail,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
