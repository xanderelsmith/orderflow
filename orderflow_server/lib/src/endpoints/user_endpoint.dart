import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Pattern 1 (Simple MVC): Direct ORM calls inside the endpoint.
class UserEndpoint extends Endpoint {
  Future<User> createUser(Session session, User user) async {
    return await User.db.insertRow(session, user);
  }

  Future<List<User>> getUsers(Session session) async {
    return await User.db.find(session);
  }
}
