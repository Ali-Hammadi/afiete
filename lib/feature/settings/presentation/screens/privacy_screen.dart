import 'package:afiete/core/constants/styles.dart';
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
        elevation: 0,
        title: const Text('Privacy & Terms', style: AppStyles.headingMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Privacy Policy',
              content:
                  'We are committed to protecting your privacy and ensuring you have a positive experience on our platform. This privacy policy explains how we collect, use, and protect your personal information.\n\n'
                  'Data Collection:\n'
                  '• We collect information you provide directly, such as your name, email, and medical history.\n'
                  '• We automatically collect certain information about your device and usage patterns.\n\n'
                  'Data Usage:\n'
                  '• Your information is used to provide and improve our services.\n'
                  '• We use your data to communicate with you about appointments and updates.\n'
                  '• We may use aggregated data for research and analytics.\n\n'
                  'Data Protection:\n'
                  '• We implement industry-standard security measures to protect your data.\n'
                  '• Your data is encrypted both in transit and at rest.\n'
                  '• We comply with all relevant data protection regulations.\n\n'
                  'Third-Party Sharing:\n'
                  '• We do not sell your personal information to third parties.\n'
                  '• We only share your information with healthcare providers as needed for your care.\n'
                  '• Third parties are bound by confidentiality agreements.',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Terms of Service',
              content:
                  'By using our platform, you agree to these terms and conditions. Please read them carefully.\n\n'
                  'Acceptable Use:\n'
                  '• You must be at least 18 years old or have parental consent.\n'
                  '• You agree not to use the platform for illegal activities.\n'
                  '• You must provide accurate and truthful information.\n\n'
                  'User Responsibilities:\n'
                  '• You are responsible for maintaining your account security.\n'
                  '• You must not share your login credentials with others.\n'
                  '• You agree to use the platform only for legitimate healthcare purposes.\n\n'
                  'Platform Limitations:\n'
                  '• Our platform is not a substitute for emergency medical care.\n'
                  '• In case of emergency, please contact local emergency services.\n'
                  '• We are not liable for interruptions or unavailability of service.\n\n'
                  'Intellectual Property:\n'
                  '• All content on our platform is protected by copyright.\n'
                  '• You may not reproduce, distribute, or transmit any content without permission.\n\n'
                  'Disclaimer:\n'
                  '• We provide medical information for educational purposes only.\n'
                  '• Consult with healthcare professionals before making medical decisions.\n'
                  '• We are not liable for any health outcomes resulting from the use of our platform.',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Cookie Policy',
              content:
                  'We use cookies to enhance your experience on our platform.\n\n'
                  'Types of Cookies:\n'
                  '• Essential cookies are necessary for the platform to function.\n'
                  '• Analytical cookies help us understand how you use our platform.\n'
                  '• Preference cookies remember your settings and preferences.\n\n'
                  'Cookie Management:\n'
                  '• You can control cookies through your browser settings.\n'
                  '• Disabling cookies may affect platform functionality.',
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
                      'Last updated: April 2026\n\n'
                      'For questions about our privacy practices or terms, please contact us.',
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
