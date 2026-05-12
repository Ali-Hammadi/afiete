import 'dart:async';
import 'package:flutter/material.dart';

/// A countdown timer widget that displays remaining time and manages resend button state.
///
/// Used in OTP verification flows to:
/// - Show remaining time before user can resend OTP
/// - Automatically disable/enable resend button
/// - Display countdown in MM:SS format
class CountdownTimer extends StatefulWidget {
  /// Initial countdown duration in seconds (default: 60s)
  final int initialSeconds;

  /// Called when countdown completes
  final VoidCallback? onCountdownComplete;

  /// Called when countdown is ticking with remaining seconds
  final ValueChanged<int>? onTick;

  /// Text style for the countdown display
  final TextStyle? textStyle;

  /// Optional custom formatter for display text
  final String Function(int seconds)? timeFormatter;

  const CountdownTimer({
    super.key,
    this.initialSeconds = 60,
    this.onCountdownComplete,
    this.onTick,
    this.textStyle,
    this.timeFormatter,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      widget.onTick?.call(_remainingSeconds);

      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        widget.onCountdownComplete?.call();
      }
    });
  }

  /// Format seconds to MM:SS display format
  String _getFormattedTime(int seconds) {
    if (widget.timeFormatter != null) {
      return widget.timeFormatter!(seconds);
    }

    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle =
        widget.textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: _remainingSeconds <= 10
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        );

    return Text(_getFormattedTime(_remainingSeconds), style: textStyle);
  }
}

/// A specialized countdown button that combines timer display with resend button.
///
/// Automatically manages:
/// - Button disabled state during countdown
/// - Timer display
/// - Resend action when countdown completes
class CountdownResendButton extends StatefulWidget {
  /// Initial countdown duration in seconds
  final int initialSeconds;

  /// Called when user taps resend button
  final Future<void> Function()? onResend;

  /// Button label when timer is running
  final String timerLabel;

  /// Button label when ready to resend
  final String resendLabel;

  /// Custom text style for timer display
  final TextStyle? timerTextStyle;

  /// Loading indicator visibility
  final bool isLoading;

  const CountdownResendButton({
    super.key,
    this.initialSeconds = 60,
    this.onResend,
    this.timerLabel = 'Resend in',
    this.resendLabel = 'Resend Code',
    this.timerTextStyle,
    this.isLoading = false,
  });

  @override
  State<CountdownResendButton> createState() => _CountdownResendButtonState();
}

class _CountdownResendButtonState extends State<CountdownResendButton> {
  late int _remainingSeconds;
  bool _isCountingDown = true;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
  }

  void _resetCountdown() {
    setState(() {
      _remainingSeconds = widget.initialSeconds;
      _isCountingDown = true;
      _isResending = false;
    });
  }

  Future<void> _handleResend() async {
    setState(() => _isResending = true);

    try {
      await widget.onResend?.call();
      _resetCountdown();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to resend: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isCountingDown)
          CountdownTimer(
            initialSeconds: _remainingSeconds,
            textStyle: widget.timerTextStyle,
            onCountdownComplete: () {
              setState(() => _isCountingDown = false);
            },
          ),
        SizedBox(height: _isCountingDown ? 8 : 0),
        AnimatedOpacity(
          opacity: _isCountingDown ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: ElevatedButton(
            onPressed: _isCountingDown || _isResending || widget.isLoading
                ? null
                : _handleResend,
            child: _isResending
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _isCountingDown ? widget.timerLabel : widget.resendLabel,
                  ),
          ),
        ),
      ],
    );
  }
}
