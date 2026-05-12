import 'package:flutter/material.dart';

/// Represents the strength level of a password
enum PasswordStrength {
  /// No password entered yet
  empty,

  /// Password doesn't meet minimum requirements
  weak,

  /// Password meets basic requirements
  fair,

  /// Password meets most requirements
  good,

  /// Password meets all requirements including special characters
  strong;

  /// Get display label for strength level
  String get label => switch (this) {
    PasswordStrength.empty => '',
    PasswordStrength.weak => 'Weak',
    PasswordStrength.fair => 'Fair',
    PasswordStrength.good => 'Good',
    PasswordStrength.strong => 'Strong',
  };

  /// Get color for strength level
  Color getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (this) {
      PasswordStrength.empty => colorScheme.outlineVariant,
      PasswordStrength.weak => colorScheme.error,
      PasswordStrength.fair => const Color(0xFFFFA500), // Orange
      PasswordStrength.good => const Color(0xFF4CAF50), // Green (lighter)
      PasswordStrength.strong => colorScheme.primary,
    };
  }
}

/// Password strength indicator widget that evaluates password quality.
///
/// Displays:
/// - Visual strength bar (4 segments)
/// - Strength label (Weak/Fair/Good/Strong)
/// - Password requirements checklist
class PasswordStrengthIndicator extends StatefulWidget {
  /// The password string to evaluate
  final String password;

  /// Custom validation rules (optional)
  final PasswordStrengthValidator? validator;

  /// Show detailed requirements list
  final bool showRequirements;

  /// Text style for requirements
  final TextStyle? requirementTextStyle;

  /// Height of the strength bar
  final double barHeight;

  /// Border radius of the strength bar
  final double borderRadius;

  /// Spacing between bar and requirements
  final double spacing;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.validator,
    this.showRequirements = true,
    this.requirementTextStyle,
    this.barHeight = 6.0,
    this.borderRadius = 3.0,
    this.spacing = 8.0,
  });

  @override
  State<PasswordStrengthIndicator> createState() =>
      _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<PasswordStrengthIndicator> {
  late PasswordStrength _strength;
  late List<PasswordRequirement> _requirements;

  @override
  void initState() {
    super.initState();
    _evaluatePassword();
  }

  @override
  void didUpdateWidget(PasswordStrengthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.password != widget.password) {
      _evaluatePassword();
    }
  }

  void _evaluatePassword() {
    final validator = widget.validator ?? _DefaultPasswordValidator();
    _requirements = validator.getRequirements(widget.password);
    _strength = validator.evaluateStrength(widget.password);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bar (5 segments)
        _StrengthBar(
          strength: _strength,
          height: widget.barHeight,
          borderRadius: widget.borderRadius,
        ),
        SizedBox(height: widget.spacing),

        // Strength label - only show after user starts typing
        if (_strength != PasswordStrength.empty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Password Strength', style: theme.textTheme.bodySmall),
              Text(
                _strength.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _strength.getColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

        // Requirements checklist
        if (widget.showRequirements) ...[
          SizedBox(height: widget.spacing * 1.5),
          ..._requirements.map(
            (req) => _RequirementItem(
              requirement: req,
              textStyle: widget.requirementTextStyle,
            ),
          ),
        ],
      ],
    );
  }
}

/// Evaluates password strength based on customizable rules
abstract class PasswordStrengthValidator {
  /// Evaluate overall password strength
  PasswordStrength evaluateStrength(String password);

  /// Get list of requirements with their completion status
  List<PasswordRequirement> getRequirements(String password);
}

/// Default password validator implementation
class _DefaultPasswordValidator implements PasswordStrengthValidator {
  static const int minLength = 8;

  @override
  PasswordStrength evaluateStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength.empty;
    }

    final requirements = getRequirements(password);
    final metCount = requirements.where((r) => r.isMet).length;

    return switch (metCount) {
      0 || 1 => PasswordStrength.weak,
      2 => PasswordStrength.fair,
      3 => PasswordStrength.good,
      4 || 5 => PasswordStrength.strong,
      _ => PasswordStrength.strong,
    };
  }

  @override
  List<PasswordRequirement> getRequirements(String password) {
    return [
      PasswordRequirement(
        label: 'At least $minLength characters',
        isMet: password.length >= minLength,
      ),
      PasswordRequirement(
        label: 'Contains uppercase letters (A-Z)',
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      PasswordRequirement(
        label: 'Contains lowercase letters (a-z)',
        isMet: password.contains(RegExp(r'[a-z]')),
      ),
      PasswordRequirement(
        label: 'Contains numbers (0-9)',
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
      PasswordRequirement(
        label: 'Contains special characters (!@#\$%^&*)',
        isMet: password.contains(RegExp('[^a-zA-Z0-9 ]')),
      ),
    ];
  }
}

/// Represents a single password requirement
class PasswordRequirement {
  final String label;
  final bool isMet;

  PasswordRequirement({required this.label, required this.isMet});
}

/// Visual strength bar with 4 segments
class _StrengthBar extends StatelessWidget {
  final PasswordStrength strength;
  final double height;
  final double borderRadius;

  const _StrengthBar({
    required this.strength,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final strengthColor = strength.getColor(context);
    final disabledColor = colorScheme.surfaceContainerHighest;

    // Calculate filled segments (0-5)
    final filledSegments = switch (strength) {
      PasswordStrength.empty => 0,
      PasswordStrength.weak => 1,
      PasswordStrength.fair => 2,
      PasswordStrength.good => 3,
      PasswordStrength.strong => 5,
    };

    return Row(
      children: List.generate(
        5,
        (index) => Expanded(
          child: Container(
            height: height,
            margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
            decoration: BoxDecoration(
              color: index < filledSegments ? strengthColor : disabledColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual requirement item with check mark
class _RequirementItem extends StatelessWidget {
  final PasswordRequirement requirement;
  final TextStyle? textStyle;

  const _RequirementItem({required this.requirement, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            requirement.isMet
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            size: 16,
            color: requirement.isMet
                ? colorScheme.primary
                : colorScheme.outline,
          ),
          const SizedBox(width: 8),
          Text(
            requirement.label,
            style:
                textStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: requirement.isMet
                      ? colorScheme.onSurface
                      : colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
