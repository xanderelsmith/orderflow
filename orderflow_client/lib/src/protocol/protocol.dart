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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'modules/billing/api/models/invoice_dto.dart' as _ijwopx60;
import 'modules/billing/internal/models/ledger_entry.dart' as _injvkp97;
import 'modules/identity/api/models/user_summary.dart' as _i8pw87en;
import 'modules/identity/internal/models/user_account.dart' as _i0978twx;
export 'greetings/greeting.dart';
export 'modules/billing/api/models/invoice_dto.dart';
export 'modules/billing/internal/models/ledger_entry.dart';
export 'modules/identity/api/models/user_summary.dart';
export 'modules/identity/internal/models/user_account.dart';
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

    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _ijwopx60.InvoiceDto) {
      return _ijwopx60.InvoiceDto.fromJson(data) as T;
    }
    if (t == _injvkp97.LedgerEntry) {
      return _injvkp97.LedgerEntry.fromJson(data) as T;
    }
    if (t == _i8pw87en.UserSummary) {
      return _i8pw87en.UserSummary.fromJson(data) as T;
    }
    if (t == _i0978twx.UserAccount) {
      return _i0978twx.UserAccount.fromJson(data) as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijwopx60.InvoiceDto?>()) {
      return (data != null ? _ijwopx60.InvoiceDto.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_injvkp97.LedgerEntry?>()) {
      return (data != null ? _injvkp97.LedgerEntry.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8pw87en.UserSummary?>()) {
      return (data != null ? _i8pw87en.UserSummary.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0978twx.UserAccount?>()) {
      return (data != null ? _i0978twx.UserAccount.fromJson(data) : null) as T;
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
      _izw8z7ou.Greeting => 'Greeting',
      _ijwopx60.InvoiceDto => 'InvoiceDto',
      _injvkp97.LedgerEntry => 'LedgerEntry',
      _i8pw87en.UserSummary => 'UserSummary',
      _i0978twx.UserAccount => 'UserAccount',
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
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _ijwopx60.InvoiceDto():
        return 'InvoiceDto';
      case _injvkp97.LedgerEntry():
        return 'LedgerEntry';
      case _i8pw87en.UserSummary():
        return 'UserSummary';
      case _i0978twx.UserAccount():
        return 'UserAccount';
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
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'InvoiceDto') {
      return deserialize<_ijwopx60.InvoiceDto>(data['data']);
    }
    if (dataClassName == 'LedgerEntry') {
      return deserialize<_injvkp97.LedgerEntry>(data['data']);
    }
    if (dataClassName == 'UserSummary') {
      return deserialize<_i8pw87en.UserSummary>(data['data']);
    }
    if (dataClassName == 'UserAccount') {
      return deserialize<_i0978twx.UserAccount>(data['data']);
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
