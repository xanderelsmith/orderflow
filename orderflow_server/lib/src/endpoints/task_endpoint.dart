import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Pattern 1 (Simple MVC): Endpoints talk directly to the database via ORM.
class TaskEndpoint extends Endpoint {
  Future<Task> createTask(Session session, Task task) async {
    if (task.title.trim().isEmpty) {
      throw ArgumentError('Task title cannot be empty.');
    }
    return await Task.db.insertRow(session, task);
  }

  Future<List<Task>> getTasks(Session session) async {
    return await Task.db.find(session);
  }
}
