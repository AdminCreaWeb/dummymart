import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/api/api_client.dart';
import '../../../utils/ui_helper.dart';
import '../../../widgets/button.dart';
import '../models/todo.dart';
import '../providers/todos.dart';

class AddTodoScreen extends HookConsumerWidget {
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoController = useTextEditingController();
    final userIdController = useTextEditingController();
    final isCompleted = useState(false);
    final isLoading = useState(false);

    Future<void> addTodo() async {
      isLoading.value = true;
      try {
        await ref.read(todosProvider.notifier).add(Todo(
              id: -1,
              todo: todoController.text,
              completed: isCompleted.value,
              userId: int.parse(userIdController.text),
            ));

        if (!context.mounted) return;
        context.go('/todos');
      } on ApiClientException catch (e) {
        if (!context.mounted) return;

        final message = e.response?.data?['message'] as String?;
        context.showTextSnackBar(message ?? 'Add todo failed');
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: SingleChildScrollView(
        child: SeparatedColumn(
          padding: const EdgeInsets.all(24),
          separatorBuilder: () => const Gap(16),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: todoController,
              decoration: const InputDecoration(
                labelText: 'Todo',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Not completed'),
                  icon: Icon(Icons.close),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Completed'),
                  icon: Icon(Icons.check),
                ),
              ],
              selected: {isCompleted.value},
              onSelectionChanged: (value) => isCompleted.value = value.first,
              showSelectedIcon: false,
            ),
            const Gap(8),
            AppButton(
              onPressed: addTodo,
              label: 'Submit',
              loading: isLoading.value,
            ),
          ],
        ),
      ),
    );
  }
}
