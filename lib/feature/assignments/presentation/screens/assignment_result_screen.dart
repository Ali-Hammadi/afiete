import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/assignments/presentation/cubits/assignments_cubit.dart';
import 'package:afiete/feature/assignments/presentation/widgets/assignment_result_summary_card.dart';
import 'package:afiete/feature/doctors/presentation/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentResultScreen extends StatelessWidget {
  final AssignmentsResultLoaded state;

  const AssignmentResultScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppStyles.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              SettingsStrings.assessmentResultTitle,
              style: AppStyles.headingMedium,
            ),
          ),
          const SizedBox(height: 14),
          CustomAssignmentResultSummaryCard(result: state.result),
          const SizedBox(height: 14),
          Text(
            SettingsStrings.suggestedSpecialistTitle,
            style: AppStyles.headingSmall,
          ),
          const SizedBox(height: 10),
          if (state.doctors.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(SettingsStrings.noSuggestedSpecialistsFoundYet),
            )
          else
            Column(
              children: state.doctors
                  .take(3)
                  .map(
                    (doctor) => CustomDoctorCard(doctor: doctor, dense: true),
                  )
                  .toList(),
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  widget: Text(
                    SettingsStrings.homeLabel,
                    style: AppStyles.bodyMedium.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      MyRoutes.homeScreen,
                      (route) => false,
                      arguments: 1,
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: CustomButton(
                  widget: Text(
                    SettingsStrings.specialistsLabel,
                    style: AppStyles.bodyMedium.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      MyRoutes.homeScreen,
                      (route) => false,
                      arguments: 1,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () =>
                  context.read<AssignmentsCubit>().retakeAssignment(),
              child: Text(SettingsStrings.retakeAssessment),
            ),
          ),
        ],
      ),
    );
  }
}
