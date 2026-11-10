import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Durable background job for sending order receipt emails.
class SendEmailCall extends FutureCall {
  Future<void> sendReceipt(Session session, OrderCreatedEvent event) async {
    session.log(
      'Background Worker: Sending receipt to ${event.userEmail} for Order #${event.orderId}',
    );
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
