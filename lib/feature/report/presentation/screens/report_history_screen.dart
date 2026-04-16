import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';
import 'package:afiete/feature/report/presentation/cubits/report_cubit.dart';
import 'package:afiete/feature/report/presentation/widgets/report_card.dart';

class ReportHistoryScreen extends StatefulWidget {
  final String userId;

  const ReportHistoryScreen({super.key, required this.userId});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  ReportType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadReportHistory();
  }

  void _loadReportHistory() {
    context.read<ReportCubit>().getReportHistory(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Report History', style: AppStyles.headingMedium),
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportHistoryLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            );
          }

          if (state is ReportHistoryEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Reports Yet',
                    style: AppStyles.headingMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your submitted reports will appear here',
                    style: AppStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is ReportError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Reports',
                    style: AppStyles.headingMedium.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadReportHistory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: AppStyles.bodyMedium.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ReportHistoryLoaded) {
            final reports = _selectedFilter != null
                ? state.reports
                      .where((r) => r.reportType == _selectedFilter)
                      .toList()
                : state.reports;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Chips
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip(
                        label: 'All',
                        isSelected: _selectedFilter == null,
                        onTap: () {
                          setState(() {
                            _selectedFilter = null;
                          });
                        },
                      ),
                      _buildFilterChip(
                        label: 'Doctor',
                        isSelected: _selectedFilter == ReportType.doctor,
                        onTap: () {
                          setState(() {
                            _selectedFilter = ReportType.doctor;
                          });
                        },
                      ),
                      _buildFilterChip(
                        label: 'App',
                        isSelected: _selectedFilter == ReportType.app,
                        onTap: () {
                          setState(() {
                            _selectedFilter = ReportType.app;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Reports List
                  if (reports.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'No reports found',
                          style: AppStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.75,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        return CustomReportCard(
                          report: reports[index],
                          onTap: () {
                            _showReportDetails(context, reports[index]);
                          },
                        );
                      },
                    ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: theme.cardColor,
      selectedColor: colorScheme.primaryContainer,
      side: BorderSide(
        color: isSelected ? colorScheme.primary : colorScheme.outline,
        width: isSelected ? 2 : 1,
      ),
      labelStyle: AppStyles.bodySmall.copyWith(
        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }

  void _showReportDetails(BuildContext context, ReportEntity report) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Report Details', style: AppStyles.headingSmall),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: AppStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              report.description,
              style: AppStyles.bodyMedium.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
