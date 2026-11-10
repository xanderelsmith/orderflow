/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:clock/clock.dart' as _io0w16m8;
import 'package:orderflow_server/src/generated/events/models/order_created_event.dart'
    as _iym4in8d;
import 'package:orderflow_server/src/generated/events/models/user_signed_up_event.dart'
    as _io1mvbzh;
import 'package:serverpod/serverpod.dart' as _is;
import '../future_calls/send_email_call.dart' as _it6tcv1d;
import '../future_calls/sync_analytics_call.dart' as _ip7dueke;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _is.SerializableModel? object);

extension ServerpodFutureCallsGetter on _is.Serverpod {
  /// Generated future calls.
  FutureCalls get futureCalls => FutureCalls();
}

class FutureCalls extends _is.FutureCallDispatch<_FutureCallRef> {
  FutureCalls._();

  factory FutureCalls() {
    return _instance;
  }

  static final FutureCalls _instance = FutureCalls._();

  _is.FutureCallManager? _futureCallManager;

  String? _serverId;

  String get _effectiveServerId {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _serverId!;
  }

  _is.FutureCallManager get _effectiveFutureCallManager {
    if (_futureCallManager == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _futureCallManager!;
  }

  @override
  void initialize(
    _is.FutureCallManager futureCallManager,
    String serverId,
  ) {
    var registeredFutureCalls = <String, _is.InvokableFutureCall>{
      'SendEmailCallSendReceiptFutureCall':
          SendEmailCallSendReceiptFutureCall(),
      'SyncAnalyticsCallTrackSignupFutureCall':
          SyncAnalyticsCallTrackSignupFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    for (final entry in registeredFutureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

  @override
  _FutureCallRef callAtTime(
    DateTime time, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          time,
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _FutureCallRef callWithDelay(
    Duration delay, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          DateTime.now().toUtc().add(delay),
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _is.RecurringFutureCallDispatch<_FutureCallRef> callRecurring({
    String? identifier,
  }) {
    return _RecurringFutureCallDispatchImpl(
      _effectiveFutureCallManager,
      _effectiveServerId,
      identifier,
    );
  }

  @override
  Future<void> cancel(String identifier) async {
    await _effectiveFutureCallManager.cancelFutureCall(identifier);
  }
}

class _RecurringFutureCallDispatchImpl
    extends _is.RecurringFutureCallDispatch<_FutureCallRef> {
  _RecurringFutureCallDispatchImpl(
    this._futureCallManager,
    this._serverId,
    this._identifier,
  );

  final _is.FutureCallManager _futureCallManager;

  final String _serverId;

  final String? _identifier;

  @override
  _FutureCallRef cron(String cronExpression) {
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          _is.Cron.parse(cronExpression).nextTime(),
          _serverId,
          _identifier,
          scheduling: _is.CronFutureCallScheduling(cron: cronExpression),
        );
      },
    );
  }

  @override
  _FutureCallRef every(
    Duration interval, {
    DateTime? start,
  }) {
    final now = _io0w16m8.clock.now().toUtc();
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          start ?? now.add(interval),
          _serverId,
          _identifier,
          scheduling: _is.IntervalFutureCallScheduling(
            interval: interval,
            start: start,
          ),
        );
      },
    );
  }
}

class _FutureCallRef {
  _FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  late final sendEmailCall = _SendEmailCallFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final syncAnalyticsCall = _SyncAnalyticsCallFutureCallDispatcher(
    _invokeFutureCall,
  );
}

class _SendEmailCallFutureCallDispatcher {
  _SendEmailCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> sendReceipt(_iym4in8d.OrderCreatedEvent event) {
    return _invokeFutureCall(
      'SendEmailCallSendReceiptFutureCall',
      event,
    );
  }
}

class _SyncAnalyticsCallFutureCallDispatcher {
  _SyncAnalyticsCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> trackSignup(_io1mvbzh.UserSignedUpEvent event) {
    return _invokeFutureCall(
      'SyncAnalyticsCallTrackSignupFutureCall',
      event,
    );
  }
}

class SendEmailCallSendReceiptFutureCall
    extends _is.FutureCall<_iym4in8d.OrderCreatedEvent>
    implements _is.InvokableFutureCall<_iym4in8d.OrderCreatedEvent> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _iym4in8d.OrderCreatedEvent? event,
  ) async {
    await _it6tcv1d.SendEmailCall().sendReceipt(
      session,
      event!,
    );
  }
}

class SyncAnalyticsCallTrackSignupFutureCall
    extends _is.FutureCall<_io1mvbzh.UserSignedUpEvent>
    implements _is.InvokableFutureCall<_io1mvbzh.UserSignedUpEvent> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _io1mvbzh.UserSignedUpEvent? event,
  ) async {
    await _ip7dueke.SyncAnalyticsCall().trackSignup(
      session,
      event!,
    );
  }
}
