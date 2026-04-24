import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/di/injection_container.dart';
import 'package:afiete/feature/chat/presentation/helpers/chat_session_navigator.dart';
import 'package:afiete/feature/sessions/domain/entities/session_entity.dart';
import 'package:afiete/feature/sessions/presentation/cubits/sessions_cubit.dart';
import 'package:afiete/feature/sessions/presentation/widgets/review_bottom_sheet.dart';
import 'package:afiete/feature/sessions/presentation/widgets/session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MySessionsScreen extends StatefulWidget {
  const MySessionsScreen({super.key});

  @override
  State<MySessionsScreen> createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {
  late final SessionsCubit _cubit;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _cubit = sl<SessionsCubit>();
    _cubit.loadUpcomingSessions();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsStrings.mySessionsTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocProvider<SessionsCubit>.value(
        value: _cubit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTabSelector(theme: theme, colorScheme: colorScheme),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SessionsCubit, SessionsState>(
                  builder: _buildStateBody,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateBody(BuildContext context, SessionsState state) {
    if (state is SessionsLoading || state is SessionsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SessionsError) {
      return Center(child: Text(state.message, style: AppStyles.bodyMedium));
    }

    if (state is UpcomingSessionsLoaded) {
      return _buildLoadedState(
        sessions: state.sessions,
        emptyMessage: SettingsStrings.noUpcomingSessions,
        isPast: false,
      );
    }

    if (state is PastSessionsLoaded) {
      return _buildLoadedState(
        sessions: state.sessions,
        emptyMessage: SettingsStrings.noPastSessions,
        isPast: true,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadedState({
    required List<SessionEntity> sessions,
    required String emptyMessage,
    required bool isPast,
  }) {
    if (sessions.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return _buildSessionsList(sessions, isPast: isPast);
  }

  Widget _buildSessionsList(
    List<SessionEntity> sessions, {
    required bool isPast,
  }) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];

        return CustomSessionCard(
          session: session,
          onAddReview: isPast
              ? () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) =>
                        CustomReviewBottomSheet(sessionId: session.id),
                  );
                }
              : null,
          onBookAgain: () =>
              _showSnackBar(SettingsStrings.bookingFeatureComingSoon),
          onReschedule: () => _handleReschedule(session),
          onJoinSession: () => _handleJoinSession(session),
          onCancel: () => _confirmCancel(context, session.id),
        );
      },
    );
  }

  Widget _buildTabSelector({
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(
              theme: theme,
              colorScheme: colorScheme,
              title: SettingsStrings.upcoming,
              isSelected: _selectedTab == 0,
              onTap: () {
                setState(() => _selectedTab = 0);
                _cubit.loadUpcomingSessions();
              },
            ),
          ),
          Expanded(
            child: _buildTabItem(
              theme: theme,
              colorScheme: colorScheme,
              title: SettingsStrings.past,
              isSelected: _selectedTab == 1,
              onTap: () {
                setState(() => _selectedTab = 1);
                _cubit.loadPastSessions();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? theme.cardColor : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.bodyMedium.copyWith(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.75),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _handleJoinSession(SessionEntity session) {
    ChatSessionNavigator.openFromSession(
      context,
      session,
      patientId: 'current_patient',
    );
  }

  Future<void> _handleReschedule(SessionEntity session) async {
    final nextSlot = session.scheduledAt.add(const Duration(days: 7));
    await _cubit.rescheduleSession(
      sessionId: session.id,
      newScheduledAt: nextSlot,
    );
    _showSnackBar(SettingsStrings.sessionRescheduledSuccessfully);
  }

  void _confirmCancel(BuildContext context, String sessionId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(SettingsStrings.cancelSessionTitle),
        content: Text(SettingsStrings.cancelSessionQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(SettingsStrings.no),
          ),
          FilledButton(
            onPressed: () {
              _cubit.cancelSession(sessionId);
              Navigator.pop(context);
              _showSnackBar(SettingsStrings.sessionCancelled);
            },
            child: Text(SettingsStrings.yesCancel),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
