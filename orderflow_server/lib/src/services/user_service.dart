import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Business & domain rules for users.
class UserService {
  Future<User> createUser(Session session, User user) async {
    return await User.db.insertRow(session, user);
  }

  Future<List<User>> listUsers(Session session) async {
    return await User.db.find(session);
  }
}
