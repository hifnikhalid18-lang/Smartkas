import 'package:flutter/material.dart';
import '../providers/savings_provider.dart';
import '../widgets/savings_goal_card.dart';
import '../widgets/add_goal_modal.dart';
import '../widgets/status_widgets.dart';
import '../utils/app_styles.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Target Menabung'),
        actions: [
          IconButton(
            onPressed: () => _showAddGoal(context),
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Tambah Target',
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListenableBuilder(
        listenable: savingsProvider,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: SafeDataWrapper(
                  isLoading: savingsProvider.isLoading,
                  isEmpty: savingsProvider.goals.isEmpty,
                  emptyMessage: 'Belum ada target menabung.\nBuat satu untuk mulai menyimpan!',
                  emptyIcon: Icons.track_changes_rounded,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: savingsProvider.goals.length,
                    itemBuilder: (context, index) {
                      final goal = savingsProvider.goals[index];
                      return SavingsGoalCard(
                        goal: goal,
                        onAddFunds: () => _showAddFundsDialog(context, goal.id),
                        onDelete: () => _showDeleteDialog(context, goal.id),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoal(context),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showAddGoal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddGoalModal(),
    );
  }

  void _showAddFundsDialog(BuildContext context, String goalId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Dana'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nominal (Rp)',
            prefixText: 'Rp ',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount > 0) {
                savingsProvider.addFunds(goalId, amount);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String goalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Target?'),
        content: const Text('Data target menabung ini akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              savingsProvider.deleteGoal(goalId);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
