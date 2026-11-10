import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import 'auth_service.dart';

class AuthFeatureEndpoint extends Endpoint {
  final _service = AuthFeatureService();

  Future<User> register(Session session, String name, String email) async {
    return await _service.registerUser(session, name, email);
  }

  Future<User?> lookupByEmail(Session session, String email) async {
    return await _service.findByEmail(session, email);
  }
}
