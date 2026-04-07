import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/di/injection_container.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sessions'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocProvider<SessionsCubit>.value(
        value: _cubit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTabSelector(),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SessionsCubit, SessionsState>(
                  builder: (context, state) {
                    if (state is SessionsLoading || state is SessionsInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is SessionsError) {
                      return Center(
                        child: Text(state.message, style: AppStyles.bodyMedium),
                      );
                    }

                    if (state is UpcomingSessionsLoaded) {
                      if (state.sessions.isEmpty) {
                        return const Center(
                          child: Text('No upcoming sessions'),
                        );
                      }
                      return _buildSessionsList(state.sessions, isPast: false);
                    }

                    if (state is PastSessionsLoaded) {
                      if (state.sessions.isEmpty) {
                        return const Center(
                          child: Text('No past sessions'),
                        );
                      }
                      return _buildSessionsList(state.sessions, isPast: true);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primaryFillColor.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTab = 0);
                _cubit.loadUpcomingSessions();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _selectedTab == 0
                      ? Colors.white
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Upcoming',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyMedium.copyWith(
                    color: _selectedTab == 0
                        ? AppColors.primaryColor
                        : AppColors.secondarytextColor,
                    fontWeight: _selectedTab == 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTab = 1);
                _cubit.loadPastSessions();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _selectedTab == 1
                      ? Colors.white
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Past',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyMedium.copyWith(
                    color: _selectedTab == 1
                        ? AppColors.primaryColor
                        : AppColors.secondarytextColor,
                    fontWeight: _selectedTab == 1
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(dynamic sessions, {required bool isPast}) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return SessionCard(
          session: session,
          onAddReview: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => ReviewBottomSheet(sessionId: session.id),
            );
          },
          onBookAgain: () => _showSnackBar('Booking feature coming soon'),
          onReschedule: () => _showSnackBar('Reschedule feature coming soon'),
          onJoinSession: () => _showSnackBar('Join session feature coming soon'),
          onCancel: () => _confirmCancel(context, session.id),
        );
      },
    );
  }

  void _confirmCancel(BuildContext context, String sessionId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Session'),
        content: const Text('Are you sure you want to cancel this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () {
              _cubit.cancelSession(sessionId);
              Navigator.pop(context);
              _showSnackBar('Session cancelled');
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
