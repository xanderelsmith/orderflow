import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/user_service.dart';

/// Pattern 2 (Layered Architecture): Delegates to UserService.
class UserEndpoint extends Endpoint {
  final _userService = UserService();

  Future<User> createUser(Session session, User user) async {
    return await _userService.createUser(session, user);
  }

  Future<List<User>> getUsers(Session session) async {
    return await _userService.listUsers(session);
  }
}
