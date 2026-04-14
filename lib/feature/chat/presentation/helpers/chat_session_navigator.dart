import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/feature/chat/presentation/screens/chat_conversation_screen.dart';
import 'package:afiete/feature/booking_assiments/domain/constants/session_type.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/sessions/domain/entities/session_entity.dart';
import 'package:flutter/material.dart';

class ChatSessionNavigator {
  static void openIfChatSession({
    required BuildContext context,
    required String sessionId,
    required String doctorId,
    required String patientId,
    required String doctorName,
    required String sessionType,
    required DateTime scheduledAt,
  }) {
    if (DateTime.now().isBefore(scheduledAt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Session starts at $scheduledAt. You can join when the time comes.',
          ),
        ),
      );
      return;
    }

    if (sessionType != SessionType.textChat) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${SessionType.displayName(sessionType)} joining is coming soon.',
          ),
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      MyRoutes.chatConversationScreen,
      arguments: ChatConversationArgs(
        sessionId: sessionId,
        doctorId: doctorId,
        patientId: patientId,
        doctorName: doctorName,
      ),
    );
  }

  static void openFromSession(
    BuildContext context,
    SessionEntity session, {
    required String patientId,
  }) {
    openIfChatSession(
      context: context,
      sessionId: session.id,
      doctorId: session.doctorId,
      patientId: patientId,
      doctorName: session.doctorName,
      sessionType: session.sessionType,
      scheduledAt: session.scheduledAt,
    );
  }

  static void openFromAppointment(
    BuildContext context,
    AppointmentEntity appointment, {
    required String doctorName,
  }) {
    openIfChatSession(
      context: context,
      sessionId: appointment.id,
      doctorId: appointment.doctorId,
      patientId: appointment.patientId,
      doctorName: doctorName,
      sessionType: appointment.sessionType,
      scheduledAt: appointment.scheduledAt,
    );
  }
}
