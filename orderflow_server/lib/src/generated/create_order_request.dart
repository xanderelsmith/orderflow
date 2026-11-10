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

abstract class CreateOrderRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CreateOrderRequest._({required this.amount});

  factory CreateOrderRequest({required double amount}) =
      _CreateOrderRequestImpl;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return CreateOrderRequest(
      amount: (jsonSerialization['amount'] as num).toDouble(),
    );
  }

  double amount;

  /// Returns a shallow copy of this [CreateOrderRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CreateOrderRequest copyWith({double? amount});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CreateOrderRequest',
      'amount': amount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CreateOrderRequest',
      'amount': amount,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CreateOrderRequestImpl extends CreateOrderRequest {
  _CreateOrderRequestImpl({required double amount}) : super._(amount: amount);

  /// Returns a shallow copy of this [CreateOrderRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CreateOrderRequest copyWith({double? amount}) {
    return CreateOrderRequest(amount: amount ?? this.amount);
  }
}
