import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/order_service.dart';

/// Pattern 2 (Layered Architecture): Transport / RPC mapping only.
class OrderEndpoint extends Endpoint {
  final _orderService = OrderService();

  Future<OrderResponse> createOrder(
    Session session,
    CreateOrderRequest request,
  ) async {
    final authInfo = session.authenticated;
    if (authInfo == null) {
      throw EndpointException(message: 'Unauthorized');
    }
    return await _orderService.createOrder(
      session,
      authInfo.userIdentifier,
      request,
    );
  }
}
