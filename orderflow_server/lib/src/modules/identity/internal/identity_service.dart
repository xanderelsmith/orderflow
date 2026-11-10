import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

class IdentityService {
  Future<UserSummary?> fetchSummary(Session session, int userId) async {
    final account = await UserAccount.db.findById(session, userId);
    if (account == null) return null;
    return UserSummary(
      userId: account.id!,
      fullName: '${account.firstName} ${account.lastName}'.trim(),
      email: account.email,
      isActive: account.isActive,
    );
  }

  Future<UserSummary> createAccount(
    Session session, {
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    final account = await UserAccount.db.insertRow(
      session,
      UserAccount(
        email: email,
        hashedPassword: 'placeholder_hashed_password',
        firstName: firstName,
        lastName: lastName,
        isActive: true,
      ),
    );
    return UserSummary(
      userId: account.id!,
      fullName: '${account.firstName} ${account.lastName}'.trim(),
      email: account.email,
      isActive: account.isActive,
    );
  }
}
