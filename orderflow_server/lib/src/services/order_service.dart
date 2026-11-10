import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../repositories/order_repository.dart';

/// Business & domain rules for orders.
class OrderService {
  final OrderStore _store;

  OrderService({OrderStore? store}) : _store = store ?? OrderStore();

  Future<OrderResponse> createOrder(
    Session session,
    String userId,
    CreateOrderRequest request,
  ) async {
    if (request.amount <= 0) {
      throw EndpointException(message: 'Order amount must be positive.');
    }

    return await session.db.transaction((tx) async {
      final order = await _store.insert(
        session,
        CustomerOrder(
          userId: userId,
          total: request.amount,
          createdAt: DateTime.now(),
        ),
        transaction: tx,
      );
      return OrderResponse(orderId: order.id!, success: true);
    });
  }
}
