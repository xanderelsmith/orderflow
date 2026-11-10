import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class PaymentFeatureService {
  Future<PaymentRecord> recordPayment(
    Session session,
    int orderId,
    double amount,
  ) async {
    return await PaymentRecord.db.insertRow(
      session,
      PaymentRecord(
        orderId: orderId,
        amount: amount,
        status: 'captured',
        createdAt: DateTime.now(),
      ),
    );
  }
}
