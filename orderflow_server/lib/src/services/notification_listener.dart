import '../generated/protocol.dart';
import '../generated/serverpod.dart';

/// Listens to real-time cross-node messages on the Serverpod MessageCentral bus.
class NotificationEventListener {
  static Future<void> initialize(Serverpod pod) async {
    final session = await pod.createSession(enableLogging: false);
    pod.server.messageCentral.addListener(session, 'order_channel', (message) {
      if (message is OrderCreatedEvent) {
        stdoutLog(
          'Real-time listener received event for Order: ${message.orderId}',
        );
      }
    });
  }

  static void stdoutLog(String message) {
    // ignore: avoid_print
    print(message);
  }
}
