import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../internal/billing_service.dart';

abstract class BillingFacade {
  static final _service = BillingService();

  /// Public contract for other modules to trigger invoicing.
  static Future<InvoiceDto> chargeUser(
    Session session,
    int userId,
    double amount,
  ) async {
    return await _service.processInvoice(session, userId, amount);
  }
}
