import 'package:equatable/equatable.dart';

class ConsultationFee extends Equatable {
  final double textChat;
  final double videoCall;
  final double voiceCall;

  const ConsultationFee({
    required this.textChat,
    required this.videoCall,
    required this.voiceCall,
  });

  double getFeeBySType(String sessionType) {
    switch (sessionType) {
      case 'text_chat':
        return textChat;
      case 'video_call':
        return videoCall;
      case 'voice_call':
        return voiceCall;
      default:
        return 0.0;
    }
  }

  @override
  List<Object> get props => [textChat, videoCall, voiceCall];
}
