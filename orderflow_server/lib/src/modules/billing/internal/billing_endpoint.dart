import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import 'billing_service.dart';

class BillingEndpoint extends Endpoint {
  final _service = BillingService();

  Future<InvoiceDto> issueInvoice(
    Session session,
    int userId,
    double amount,
  ) async {
    return await _service.processInvoice(session, userId, amount);
  }
}
