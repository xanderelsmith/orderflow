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

abstract class OrderResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OrderResponse._({
    required this.orderId,
    required this.success,
  });

  factory OrderResponse({
    required int orderId,
    required bool success,
  }) = _OrderResponseImpl;

  factory OrderResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderResponse(
      orderId: jsonSerialization['orderId'] as int,
      success: _isc.BoolJsonExtension.fromJson(jsonSerialization['success']),
    );
  }

  int orderId;

  bool success;

  /// Returns a shallow copy of this [OrderResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OrderResponse copyWith({
    int? orderId,
    bool? success,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderResponse',
      'orderId': orderId,
      'success': success,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderResponse',
      'orderId': orderId,
      'success': success,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _OrderResponseImpl extends OrderResponse {
  _OrderResponseImpl({
    required int orderId,
    required bool success,
  }) : super._(
         orderId: orderId,
         success: success,
       );

  /// Returns a shallow copy of this [OrderResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OrderResponse copyWith({
    int? orderId,
    bool? success,
  }) {
    return OrderResponse(
      orderId: orderId ?? this.orderId,
      success: success ?? this.success,
    );
  }
}
