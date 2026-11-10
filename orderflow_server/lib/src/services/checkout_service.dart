import '../generated/protocol.dart';
import '../generated/serverpod.dart';

/// Pattern 5 (Event-Driven): Publishes real-time events and queues durable FutureCalls.
class CheckoutService {
  Future<void> completeCheckout(
    Session session, {
    required int orderId,
    required String email,
    required double amount,
  }) async {
    final event = OrderCreatedEvent(
      orderId: orderId,
      userEmail: email,
      totalAmount: amount,
    );

    // 1. Fire-and-forget real-time broadcast via Serverpod Message Bus.
    await session.messages.postMessage('order_channel', event);

    // 2. Queue durable asynchronous background job (Serverpod 4 typed FutureCalls).
    await session.serverpod.futureCalls
        .callWithDelay(const Duration(seconds: 1))
        .sendEmailCall
        .sendReceipt(event);
  }
}
