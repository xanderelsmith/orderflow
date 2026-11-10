import 'package:serverpod/serverpod.dart';

/// Shared infrastructure helper with zero business logic.
class TransactionRunner {
  static Future<T> run<T>(
    Session session,
    Future<T> Function(Transaction tx) action,
  ) {
    return session.db.transaction(action);
  }
}
