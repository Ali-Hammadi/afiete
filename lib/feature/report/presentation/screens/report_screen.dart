import 'package:afiete/core/constants/settings_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/report/data/datasources/mock_report_data.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';
import 'package:afiete/feature/report/presentation/cubits/report_cubit.dart';
import 'package:afiete/feature/report/presentation/widgets/report_form_widget.dart';
import 'package:afiete/feature/report/presentation/widgets/report_header_widget.dart';
import 'package:afiete/feature/report/presentation/widgets/report_reason_card.dart';
import 'package:afiete/feature/report/presentation/widgets/section_divider_widget.dart';

class ReportScreen extends StatefulWidget {
  final ReportType reportType;
  final String? doctorId;
  final String? doctorName;
  final String? sessionId;
  final String userId;

  const ReportScreen({
    super.key,
    required this.reportType,
    required this.userId,
    this.doctorId,
    this.doctorName,
    this.sessionId,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late TextEditingController _descriptionController;
  ReportReason? _selectedReason;
  late List<Map<String, dynamic>> _reportReasons;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _loadReportReasons();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadReportReasons() {
    if (widget.reportType == ReportType.doctor) {
      _reportReasons = MockReportData.getMockDoctorReportReasons();
    } else {
      _reportReasons = MockReportData.getMockAppReportReasons();
    }
  }

  String _getScreenTitle() {
    if (widget.reportType == ReportType.doctor) {
      return SettingsStrings.reportDoctorTitle;
    } else if (widget.reportType == ReportType.session) {
      return SettingsStrings.reportSessionTitle;
    } else {
      return SettingsStrings.reportIssueTitle;
    }
  }

  String _getHeaderDescription() {
    if (widget.reportType == ReportType.doctor) {
      return SettingsStrings.reportDoctorDescription;
    } else if (widget.reportType == ReportType.session) {
      return SettingsStrings.reportSessionDescription;
    } else {
      return SettingsStrings.reportIssueDescription;
    }
  }

  bool _isFormValid() {
    return _selectedReason != null &&
        _descriptionController.text.trim().isNotEmpty;
  }

  void _submitReport() {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(SettingsStrings.pleaseSelectReasonAndProvideDetails),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    context.read<ReportCubit>().submitReport(
      userId: widget.userId,
      reportType: widget.reportType,
      targetId: widget.doctorId ?? widget.sessionId,
      targetName: widget.doctorName,
      reason: _selectedReason!,
      description: _descriptionController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: true,
        title: Text(_getScreenTitle(), style: AppStyles.headingMedium),
      ),
      body: BlocListener<ReportCubit, ReportState>(
        listener: (context, state) {
          if (state is ReportSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(SettingsStrings.reportSubmittedSuccessfully),
                backgroundColor: colorScheme.primary,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 24),
              _buildReasonSection(),
              const SizedBox(height: 24),
              const CustomSectionDividerWidget(),
              _buildDescriptionSection(),
              const SizedBox(height: 24),
              _buildSubmitButton(colorScheme: colorScheme),
              const SizedBox(height: 12),
              _buildInfoBanner(colorScheme: colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return CustomReportHeaderWidget(
      title: SettingsStrings.reportConfidentialTitle,
      description: _getHeaderDescription(),
      icon: const Icon(Icons.info),
    );
  }

  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(SettingsStrings.selectReason, style: AppStyles.headingSmall),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reportReasons.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final reason = _reportReasons[index];
            final reportReason = ReportReason.values.firstWhere(
              (e) => e.name == reason['key'],
              orElse: () => ReportReason.other,
            );

            return CustomReportReasonCard(
              label: reason['label'],
              icon: reason['icon'],
              color: reason['color'],
              isSelected: _selectedReason == reportReason,
              onTap: () {
                setState(() {
                  _selectedReason = reportReason;
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return CustomReportFormWidget(
      label: SettingsStrings.additionalDetails,
      hintText: SettingsStrings.reportDescriptionHint,
      controller: _descriptionController,
      maxLines: 6,
      maxLength: 500,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget _buildSubmitButton({required ColorScheme colorScheme}) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        final isLoading = state is ReportSubmitting;

        return CustomButton(
          widget: Text(
            isLoading
                ? SettingsStrings.submitting
                : SettingsStrings.submitReport,
            style: AppStyles.bodyLarge.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: isLoading ? null : _submitReport,
        );
      },
    );
  }

  Widget _buildInfoBanner({required ColorScheme colorScheme}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              SettingsStrings.reportWillBeReviewed,
              style: AppStyles.bodySmall.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
