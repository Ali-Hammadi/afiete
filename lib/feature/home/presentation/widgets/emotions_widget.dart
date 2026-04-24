import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/feeling/presentation/cubit/feeling_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomEmotionsWidget extends StatelessWidget {
  const CustomEmotionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.padding),
      child: BlocBuilder<FeelingCubit, FeelingState>(
        builder: (context, state) {
          final selectedFeeling = switch (state) {
            FeelingLoaded() => state.selectedFeeling,
            FeelingError() => state.selectedFeeling,
            _ => null,
          };

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _items
                .map((item) {
                  final isSelected = selectedFeeling == item.feeling;
                  return InkWell(
                    borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                    onTap: () {
                      context.read<FeelingCubit>().selectFeeling(item.feeling);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 58,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.primaryContainer.withValues(
                                alpha: 0.45,
                              ),
                        borderRadius: BorderRadius.circular(
                          AppStyles.borderRadius,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 24,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: AppStyles.bodySmall.copyWith(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          );
        },
      ),
    );
  }

  static List<_FeelingItem> get _items => [
    _FeelingItem(
      feeling: FeelingType.happy,
      icon: Icons.sentiment_very_satisfied_rounded,
      label: SettingsStrings.feelingHappyLabel,
    ),
    _FeelingItem(
      feeling: FeelingType.sad,
      icon: Icons.sentiment_very_dissatisfied_rounded,
      label: SettingsStrings.feelingSadLabel,
    ),
    _FeelingItem(
      feeling: FeelingType.angry,
      icon: Icons.mood_bad_rounded,
      label: SettingsStrings.feelingAngryLabel,
    ),
    _FeelingItem(
      feeling: FeelingType.neutral,
      icon: Icons.sentiment_neutral_rounded,
      label: SettingsStrings.feelingNeutralLabel,
    ),
    _FeelingItem(
      feeling: FeelingType.anxious,
      icon: Icons.psychology_alt_rounded,
      label: SettingsStrings.feelingAnxiousLabel,
    ),
  ];
}

class _FeelingItem {
  final FeelingType feeling;
  final IconData icon;
  final String label;

  const _FeelingItem({
    required this.feeling,
    required this.icon,
    required this.label,
  });
}
