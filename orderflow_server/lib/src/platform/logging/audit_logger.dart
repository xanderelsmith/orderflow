import 'package:serverpod/serverpod.dart';

/// Shared audit logging utility with zero domain knowledge.
class AuditLogger {
  static void info(Session session, String module, String message) {
    session.log('[$module] $message');
  }
}
