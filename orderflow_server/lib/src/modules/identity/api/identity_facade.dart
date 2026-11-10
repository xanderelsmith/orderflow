import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../internal/identity_service.dart';

abstract class IdentityFacade {
  static final _service = IdentityService();

  /// Other modules call ONLY this method to retrieve user details.
  static Future<UserSummary?> getUserSummary(
    Session session,
    int userId,
  ) async {
    return await _service.fetchSummary(session, userId);
  }
}
