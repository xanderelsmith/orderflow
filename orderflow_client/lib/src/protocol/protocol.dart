/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:orderflow_client/src/protocol/features/orders/models/order_record.dart'
    as _ieiuqyoi;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'features/auth/models/user.dart' as _iq3jm3fb;
import 'features/orders/models/endpoint_exception.dart' as _iu4eqa4d;
import 'features/orders/models/order_item.dart' as _iqdkhoq3;
import 'features/orders/models/order_record.dart' as _iq610txb;
import 'features/payments/models/payment_record.dart' as _iddcrq2a;
import 'greetings/greeting.dart' as _izw8z7ou;
export 'features/auth/models/user.dart';
export 'features/orders/models/endpoint_exception.dart';
export 'features/orders/models/order_item.dart';
export 'features/orders/models/order_record.dart';
export 'features/payments/models/payment_record.dart';
export 'greetings/greeting.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iq3jm3fb.User) {
      return _iq3jm3fb.User.fromJson(data) as T;
    }
    if (t == _iu4eqa4d.EndpointException) {
      return _iu4eqa4d.EndpointException.fromJson(data) as T;
    }
    if (t == _iqdkhoq3.OrderItem) {
      return _iqdkhoq3.OrderItem.fromJson(data) as T;
    }
    if (t == _iq610txb.OrderRecord) {
      return _iq610txb.OrderRecord.fromJson(data) as T;
    }
    if (t == _iddcrq2a.PaymentRecord) {
      return _iddcrq2a.PaymentRecord.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _isc.getType<_iq3jm3fb.User?>()) {
      return (data != null ? _iq3jm3fb.User.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iu4eqa4d.EndpointException?>()) {
      return (data != null ? _iu4eqa4d.EndpointException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iqdkhoq3.OrderItem?>()) {
      return (data != null ? _iqdkhoq3.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iq610txb.OrderRecord?>()) {
      return (data != null ? _iq610txb.OrderRecord.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iddcrq2a.PaymentRecord?>()) {
      return (data != null ? _iddcrq2a.PaymentRecord.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == List<_ieiuqyoi.OrderRecord>) {
      return (data as List)
              .map((e) => deserialize<_ieiuqyoi.OrderRecord>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iq3jm3fb.User => 'User',
      _iu4eqa4d.EndpointException => 'EndpointException',
      _iqdkhoq3.OrderItem => 'OrderItem',
      _iq610txb.OrderRecord => 'OrderRecord',
      _iddcrq2a.PaymentRecord => 'PaymentRecord',
      _izw8z7ou.Greeting => 'Greeting',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('orderflow.', '');
    }

    switch (data) {
      case _iq3jm3fb.User():
        return 'User';
      case _iu4eqa4d.EndpointException():
        return 'EndpointException';
      case _iqdkhoq3.OrderItem():
        return 'OrderItem';
      case _iq610txb.OrderRecord():
        return 'OrderRecord';
      case _iddcrq2a.PaymentRecord():
        return 'PaymentRecord';
      case _izw8z7ou.Greeting():
        return 'Greeting';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'User') {
      return deserialize<_iq3jm3fb.User>(data['data']);
    }
    if (dataClassName == 'EndpointException') {
      return deserialize<_iu4eqa4d.EndpointException>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_iqdkhoq3.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderRecord') {
      return deserialize<_iq610txb.OrderRecord>(data['data']);
    }
    if (dataClassName == 'PaymentRecord') {
      return deserialize<_iddcrq2a.PaymentRecord>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('orderflow', this);
    _iacc.Protocol().registerHostProtocol('orderflow', this);
  }

  @override
  String getModuleName() => 'orderflow';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
