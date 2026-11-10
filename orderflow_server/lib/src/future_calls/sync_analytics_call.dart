import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Durable background job for syncing signup/order analytics.
class SyncAnalyticsCall extends FutureCall {
  Future<void> trackSignup(Session session, UserSignedUpEvent event) async {
    session.log(
      'Analytics Worker: Syncing signup for ${event.email} (${event.userId})',
    );
  }
}
