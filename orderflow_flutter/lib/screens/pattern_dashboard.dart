import 'package:flutter/material.dart';
import 'package:orderflow_client/orderflow_client.dart';

import '../client.dart';
import '../widgets/backend_shell.dart';

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _logs = <RpcLogEntry>[];

  final _taskTitleController = TextEditingController(text: 'Ship MVC backend');
  final _taskUserIdController = TextEditingController(text: '1');
  bool _taskCompleted = false;
  List<Task> _tasks = [];

  final _userNameController = TextEditingController(text: 'Ada Lovelace');
  final _userEmailController = TextEditingController(text: 'ada@example.com');
  bool _userActive = true;
  List<User> _users = [];

  bool _loading = false;

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskUserIdController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  void _addLog(String action, Object? result, {bool isError = false}) {
    setState(() {
      _logs.insert(
        0,
        RpcLogEntry(
          timestamp: DateTime.now(),
          action: action,
          serverUrl: serverUrlNotifier.value,
          isError: isError,
          payload: isError ? '$result' : prettyJson(result),
        ),
      );
    });
  }

  Future<void> _createTask() async {
    setState(() => _loading = true);
    try {
      final created = await client.task.createTask(
        Task(
          title: _taskTitleController.text.trim(),
          isCompleted: _taskCompleted,
          userId: int.tryParse(_taskUserIdController.text.trim()) ?? 1,
          createdAt: DateTime.now(),
        ),
      );
      _addLog('task.createTask', created.toJson());
      await _loadTasks();
    } catch (e) {
      _addLog('task.createTask', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadTasks() async {
    try {
      final list = await client.task.getTasks();
      setState(() => _tasks = list);
      _addLog('task.getTasks', list.map((t) => t.toJson()).toList());
    } catch (e) {
      _addLog('task.getTasks', e, isError: true);
    }
  }

  Future<void> _createUser() async {
    setState(() => _loading = true);
    try {
      final created = await client.user.createUser(
        User(
          name: _userNameController.text.trim(),
          email: _userEmailController.text.trim(),
          isActive: _userActive,
        ),
      );
      _addLog('user.createUser', created.toJson());
      await _loadUsers();
    } catch (e) {
      _addLog('user.createUser', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadUsers() async {
    try {
      final list = await client.user.getUsers();
      setState(() => _users = list);
      _addLog('user.getUsers', list.map((u) => u.toJson()).toList());
    } catch (e) {
      _addLog('user.getUsers', e, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackendShell(
      patternTag: '01-simple-mvc',
      patternTitle: 'Simple MVC (Endpoints + ORM)',
      patternDescription: 'Endpoints talk straight to Task.db and User.db.',
      logs: _logs,
      onClearLogs: () => setState(_logs.clear),
      onLog: _addLog,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TaskEndpoint (client.task)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 240,
                        child: TextField(
                          controller: _taskTitleController,
                          decoration: const InputDecoration(
                            labelText: 'Task title',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        child: TextField(
                          controller: _taskUserIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'User ID',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilterChip(
                        label: const Text('Completed'),
                        selected: _taskCompleted,
                        onSelected: (v) => setState(() => _taskCompleted = v),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _createTask,
                        icon: const Icon(Icons.add_task, size: 18),
                        label: const Text('Create Task'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loadTasks,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text('Load Tasks (${_tasks.length})'),
                      ),
                    ],
                  ),
                  if (_tasks.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    for (final t in _tasks)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          t.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                        ),
                        title: Text(t.title),
                        subtitle: Text('id=${t.id} · userId=${t.userId}'),
                      ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UserEndpoint (client.user)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _userNameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _userEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilterChip(
                        label: const Text('Active'),
                        selected: _userActive,
                        onSelected: (v) => setState(() => _userActive = v),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _createUser,
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Create User'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loadUsers,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text('Load Users (${_users.length})'),
                      ),
                    ],
                  ),
                  if (_users.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    for (final u in _users)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.person_outline),
                        title: Text('${u.name} (${u.email})'),
                        subtitle: Text('id=${u.id} · active=${u.isActive}'),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
