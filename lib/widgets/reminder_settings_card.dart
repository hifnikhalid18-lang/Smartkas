import 'package:flutter/material.dart';
import '../utils/app_styles.dart';
import '../providers/settings_provider.dart';
import 'reusable_card.dart';

class ReminderSettingsCard extends StatelessWidget {
  const ReminderSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsProvider,
      builder: (context, _) {
        final hour = settingsProvider.reminderHour.toString().padLeft(2, '0');
        final minute = settingsProvider.reminderMinute.toString().padLeft(2, '0');
        
        return ReusableCard(
          margin: const EdgeInsets.only(top: AppSpacing.sm),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.notifications_active_rounded, color: AppColors.accent),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pengingat Harian', style: AppTextStyles.body),
                        Text(
                          settingsProvider.isReminderEnabled 
                              ? 'Aktif pada $hour:$minute' 
                              : 'Nonaktif',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: settingsProvider.isReminderEnabled,
                    onChanged: (value) => settingsProvider.toggleReminder(value),
                    activeColor: AppColors.accent,
                  ),
                ],
              ),
              if (settingsProvider.isReminderEnabled) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Divider(color: AppColors.border, thickness: 0.5),
                ),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: AppColors.secondaryText, size: 20),
                        const SizedBox(width: AppSpacing.md),
                        const Text('Atur Jam Pengingat', style: AppTextStyles.body),
                        const Spacer(),
                        Text('$hour:$minute', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settingsProvider.reminderHour,
        minute: settingsProvider.reminderMinute,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accent,
              onPrimary: Colors.white,
              onSurface: AppColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      settingsProvider.setReminderTime(picked.hour, picked.minute);
    }
  }
}
