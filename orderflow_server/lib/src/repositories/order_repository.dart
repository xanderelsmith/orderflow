import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Optional data-access layer encapsulating CustomerOrder ORM operations.
/// Named OrderStore so it does not collide with Serverpod's generated
/// CustomerOrderRepository class.
class OrderStore {
  Future<CustomerOrder> insert(
    Session session,
    CustomerOrder order, {
    Transaction? transaction,
  }) async {
    return await CustomerOrder.db.insertRow(
      session,
      order,
      transaction: transaction,
    );
  }

  Future<List<CustomerOrder>> findByUserId(
    Session session,
    String userId,
  ) async {
    return await CustomerOrder.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }
}
