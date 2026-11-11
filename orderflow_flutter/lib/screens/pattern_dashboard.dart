import 'package:flutter/material.dart';
import 'package:orderflow_client/orderflow_client.dart';

import '../client.dart';
import '../widgets/product_shell.dart';

enum _TaskFilter { all, open, done }

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _activity = <ActivityLogItem>[];

  final _taskTitleController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();

  List<Task> _tasks = [];
  List<User> _users = [];
  int? _selectedAssigneeId;
  bool _newTaskCompleted = false;
  _TaskFilter _filter = _TaskFilter.all;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  void _log(String action, Object? detail, {bool isError = false}) {
    if (!mounted) return;
    setState(() {
      _activity.insert(
        0,
        ActivityLogItem(
          timestamp: DateTime.now(),
          action: action,
          isError: isError,
          detail: isError ? '$detail' : prettyPayload(detail),
        ),
      );
    });
  }

  Future<void> _refreshAll() async {
    await Future.wait([_loadTasks(), _loadUsers()]);
  }

  Future<void> _loadTasks() async {
    try {
      final list = await client.task.getTasks();
      if (mounted) setState(() => _tasks = list);
      _log('task.getTasks', list.map((t) => t.toJson()).toList());
    } catch (e) {
      _log('task.getTasks', e, isError: true);
    }
  }

  Future<void> _loadUsers() async {
    try {
      final list = await client.user.getUsers();
      if (mounted) {
        setState(() {
          _users = list;
          if (_selectedAssigneeId == null && list.isNotEmpty) {
            _selectedAssigneeId = list.first.id;
          }
        });
      }
      _log('user.getUsers', list.map((u) => u.toJson()).toList());
    } catch (e) {
      _log('user.getUsers', e, isError: true);
    }
  }

  Future<void> _createTask() async {
    final title = _taskTitleController.text.trim();
    if (title.isEmpty) return;
    setState(() => _busy = true);
    try {
      final created = await client.task.createTask(
        Task(
          title: title,
          isCompleted: _newTaskCompleted,
          userId: _selectedAssigneeId ?? 1,
          createdAt: DateTime.now(),
        ),
      );
      _taskTitleController.clear();
      _log('task.createTask', created.toJson());
      await _loadTasks();
    } catch (e) {
      _log('task.createTask', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createUser() async {
    final name = _userNameController.text.trim();
    final email = _userEmailController.text.trim();
    if (name.isEmpty || email.isEmpty) return;
    setState(() => _busy = true);
    try {
      final created = await client.user.createUser(
        User(name: name, email: email, isActive: true),
      );
      _userNameController.clear();
      _userEmailController.clear();
      _log('user.createUser', created.toJson());
      await _loadUsers();
      if (mounted && created.id != null) {
        setState(() => _selectedAssigneeId = created.id);
      }
    } catch (e) {
      _log('user.createUser', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.isCompleted).length;
    final openCount = _tasks.length - completedCount;
    final visibleTasks = switch (_filter) {
      _TaskFilter.all => _tasks,
      _TaskFilter.open => _tasks.where((t) => !t.isCompleted).toList(),
      _TaskFilter.done => _tasks.where((t) => t.isCompleted).toList(),
    };

    return ProductShell(
      editionLabel: 'MVP · Simple MVC',
      subtitle:
          'Minimal fulfillment workspace: quick team directory and task board backed directly by Task.db and User.db.',
      activity: _activity,
      onClearActivity: () => setState(_activity.clear),
      onLog: _log,
      onClientChanged: _refreshAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _kpiCard(context, 'Total Tasks', '${_tasks.length}', Icons.checklist),
              _kpiCard(context, 'Open', '$openCount', Icons.pending_actions),
              _kpiCard(
                context,
                'Completed',
                '$completedCount',
                Icons.task_alt,
              ),
              _kpiCard(
                context,
                'Team Members',
                '${_users.length}',
                Icons.group_outlined,
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoCol = constraints.maxWidth >= 820;
              final tasksPanel = _buildTasksCard(context, visibleTasks);
              final usersPanel = _buildUsersCard(context);
              if (twoCol) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: tasksPanel),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: usersPanel),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  tasksPanel,
                  const SizedBox(height: 20),
                  usersPanel,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 250,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.primaryContainer,
                child: Icon(icon, color: colors.onPrimaryContainer),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksCard(BuildContext context, List<Task> visibleTasks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Fulfillment Tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                SegmentedButton<_TaskFilter>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: _TaskFilter.all, label: Text('All')),
                    ButtonSegment(value: _TaskFilter.open, label: Text('Open')),
                    ButtonSegment(value: _TaskFilter.done, label: Text('Done')),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (v) => setState(() => _filter = v.first),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _taskTitleController,
                    decoration: const InputDecoration(
                      labelText: 'New task',
                      hintText: 'Pack order #104...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _createTask(),
                  ),
                ),
                if (_users.isNotEmpty)
                  DropdownButton<int>(
                    value: _users.any((u) => u.id == _selectedAssigneeId)
                        ? _selectedAssigneeId
                        : _users.first.id,
                    items: [
                      for (final u in _users)
                        if (u.id != null)
                          DropdownMenuItem(
                            value: u.id,
                            child: Text(u.name),
                          ),
                    ],
                    onChanged: (v) => setState(() => _selectedAssigneeId = v),
                  ),
                FilterChip(
                  label: const Text('Completed'),
                  selected: _newTaskCompleted,
                  onSelected: (v) => setState(() => _newTaskCompleted = v),
                ),
                FilledButton.icon(
                  onPressed: _busy ? null : _createTask,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            if (visibleTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text('No tasks yet. Add your first task above.'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleTasks.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final task = visibleTasks[index];
                  final owner = _users
                      .where((u) => u.id == task.userId)
                      .map((u) => u.name)
                      .firstOrNull;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted ? Colors.green : null,
                    ),
                    title: Text(task.title),
                    subtitle: Text(
                      owner != null
                          ? 'Assigned to $owner'
                          : 'Assignee #${task.userId}',
                    ),
                    trailing: Chip(
                      label: Text(task.isCompleted ? 'Done' : 'Open'),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Team Directory',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _refreshAll,
                  icon: const Icon(Icons.refresh, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _userEmailController,
              decoration: const InputDecoration(
                labelText: 'Work email',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: _busy ? null : _createUser,
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('Add Member'),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            if (_users.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('No members yet.')),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _users.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final u = _users[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text(
                        u.name.isEmpty ? '?' : u.name[0].toUpperCase(),
                      ),
                    ),
                    title: Text(u.name),
                    subtitle: Text(u.email),
                    trailing: Text('#${u.id ?? '-'}'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
