import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import 'identity_service.dart';

class IdentityEndpoint extends Endpoint {
  final _service = IdentityService();

  Future<UserSummary> registerAccount(
    Session session,
    String email,
    String firstName,
    String lastName,
  ) async {
    return await _service.createAccount(
      session,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<UserSummary?> getUserSummary(Session session, int userId) async {
    return await _service.fetchSummary(session, userId);
  }
}
