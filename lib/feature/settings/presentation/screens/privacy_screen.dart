import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          SettingsStrings.privacyTermsTitle,
          style: AppStyles.headingMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: SettingsStrings.privacyPolicyTitle,
              content: SettingsStrings.privacyPolicyBody,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: SettingsStrings.termsOfServiceTitle,
              content: SettingsStrings.termsBody,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: SettingsStrings.cookiePolicyTitle,
              content: SettingsStrings.cookieBody,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${SettingsStrings.privacyLastUpdated}\n\n${SettingsStrings.privacyContactHint}',
                      style: AppStyles.bodySmall.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: AppStyles.headingSmall.copyWith(color: colorScheme.primary),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: AppStyles.bodyMedium.copyWith(
            color: colorScheme.onSurface,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
