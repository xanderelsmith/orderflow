import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Durable background job for sending order receipt emails.
///
/// NOTE (Tutorial / Demonstration):
/// This worker simulates email delivery via `session.log(...)` so that readers
/// can run and test the complete architecture out-of-the-box without requiring
/// external SMTP credentials or paid API keys.
///
/// In a production deployment, replace `session.log` with your email delivery provider:
/// ```dart
/// // Option 1: SendGrid / Resend via HTTP
/// await http.post(
///   Uri.parse('https://api.resend.com/emails'),
///   headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
///   body: jsonEncode({
///     'from': 'orders@yourdomain.com',
///     'to': event.userEmail,
///     'subject': 'Order #${event.orderId} Confirmed',
///     'text': 'Your order for \$${event.totalAmount} is confirmed!',
///   }),
/// );
///
/// // Option 2: SMTP with the `mailer` package
/// final smtpServer = gmail('your-email@gmail.com', 'your-app-password');
/// final message = Message()
///   ..from = const Address('your-email@gmail.com', 'OrderFlow')
///   ..recipients.add(event.userEmail)
///   ..subject = 'Receipt for Order #${event.orderId}'
///   ..text = 'Total: \$${event.totalAmount}';
/// await send(message, smtpServer);
/// ```
class SendEmailCall extends FutureCall {
  Future<void> sendReceipt(Session session, OrderCreatedEvent event) async {
    session.log(
      'Background Worker: Sending receipt to ${event.userEmail} for Order #${event.orderId} (\$${event.totalAmount})',
    );
    // Simulate network latency for background email provider call
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
