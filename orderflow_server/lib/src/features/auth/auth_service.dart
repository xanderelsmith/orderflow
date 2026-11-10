import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class AuthFeatureService {
  Future<User?> findByEmail(Session session, String email) async {
    return await User.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );
  }

  Future<User> registerUser(Session session, String name, String email) async {
    return await User.db.insertRow(
      session,
      User(name: name, email: email, isActive: true),
    );
  }
}
