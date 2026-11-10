import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../platform/database/transaction_runner.dart';
import '../../../platform/logging/audit_logger.dart';
// Imports IdentityFacade ONLY, never internal UserAccount.
import '../../identity/api/identity_facade.dart';

class BillingService {
  Future<InvoiceDto> processInvoice(
    Session session,
    int userId,
    double amount,
  ) async {
    // 1. Fetch data through the public contract.
    final user = await IdentityFacade.getUserSummary(session, userId);
    if (user == null || !user.isActive) {
      throw StateError('Cannot invoice an inactive or non-existent user.');
    }

    // 2. Perform billing action locally inside a platform transaction.
    final entry = await TransactionRunner.run(session, (tx) async {
      return await LedgerEntry.db.insertRow(
        session,
        LedgerEntry(
          userId: user.userId,
          amount: amount,
          createdAt: DateTime.now(),
        ),
        transaction: tx,
      );
    });

    AuditLogger.info(
      session,
      'billing',
      'Generated charge for ${user.fullName} (${user.email}) of \$$amount',
    );

    return InvoiceDto(
      ledgerEntryId: entry.id!,
      userId: entry.userId,
      amount: entry.amount,
      issuedAt: entry.createdAt,
    );
  }
}
