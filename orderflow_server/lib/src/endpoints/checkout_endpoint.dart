import 'package:serverpod/serverpod.dart';
import '../services/checkout_service.dart';

class CheckoutEndpoint extends Endpoint {
  final _checkoutService = CheckoutService();

  Future<void> completeCheckout(
    Session session,
    int orderId,
    String email,
    double amount,
  ) async {
    await _checkoutService.completeCheckout(
      session,
      orderId: orderId,
      email: email,
      amount: amount,
    );
  }
}
