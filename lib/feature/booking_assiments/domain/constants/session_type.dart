import 'package:afiete/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

abstract class SessionType {
  static const String textChat = 'text_chat';
  static const String videoCall = 'video_call';
  static const String voiceCall = 'voice_call';

  static const List<String> all = [textChat, videoCall, voiceCall];

  static String displayName(String type) {
    switch (type) {
      case textChat:
        return 'Text Chat';
      case videoCall:
        return 'Video Call';
      case voiceCall:
        return 'Voice Call';
      default:
        return type;
    }
  }

  static IconData icon(String type) {
    switch (type) {
      case textChat:
        return Icons.chat_bubble_outline;
      case videoCall:
        return Icons.videocam_outlined;
      case voiceCall:
        return Icons.call_outlined;
      default:
        return Icons.info_outline;
    }
  }

  static Widget displayWithIcon(String type, {TextStyle? textStyle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon(type), size: 24, color: AppColors.primaryColor),
        const SizedBox(width: 6),
        Text(displayName(type), style: textStyle),
      ],
    );
  }
}
