import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class OrderFeatureService {
  Future<OrderRecord> checkout(
    Session session,
    String userId,
    int count,
    double price,
  ) async {
    if (count <= 0) throw ArgumentError('Count must be positive.');

    final record = OrderRecord(
      userId: userId,
      itemCount: count,
      totalPrice: price,
    );

    return await OrderRecord.db.insertRow(session, record);
  }

  Future<List<OrderRecord>> getOrderHistory(
    Session session,
    String userId,
  ) async {
    return await OrderRecord.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }
}
