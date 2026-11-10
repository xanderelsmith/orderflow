import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'payment_service.dart';

class PaymentFeatureEndpoint extends Endpoint {
  final _service = PaymentFeatureService();

  Future<PaymentRecord> chargeOrder(
    Session session,
    int orderId,
    double amount,
  ) async {
    return await _service.recordPayment(session, orderId, amount);
  }
}
