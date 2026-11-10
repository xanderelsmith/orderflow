import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'order_service.dart';

/// Pattern 3 (Package by Feature): Vertical slice for orders.
class OrderFeatureEndpoint extends Endpoint {
  final OrderFeatureService _service = OrderFeatureService();

  Future<OrderRecord> placeOrder(
    Session session,
    int itemCount,
    double totalPrice,
  ) async {
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw EndpointException(message: 'Must be logged in to order');
    }

    return await _service.checkout(
      session,
      authInfo.userIdentifier,
      itemCount,
      totalPrice,
    );
  }

  Future<List<OrderRecord>> listMyOrders(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];

    return await _service.getOrderHistory(session, authInfo.userIdentifier);
  }
}
