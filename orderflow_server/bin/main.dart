import 'package:orderflow_server/server.dart';

/// This is the starting point for your Serverpod server.
void main(List<String> args) {
  final effectiveArgs = List<String>.from(args);

  // [Branch Switching Automation]:
  // Automatically apply database migrations in development mode if not explicitly specified.
  // This allows team members to switch between architectural pattern branches (e.g.,
  // 01-simple-mvc, 02-layered, etc.) and launch the server immediately without running
  // into missing-table exceptions or needing manual migration CLI commands.
  if (!effectiveArgs.contains('--apply-migrations') &&
      !effectiveArgs.contains('--no-apply-migrations')) {
    effectiveArgs.add('--apply-migrations');
  }

  run(effectiveArgs);
}
