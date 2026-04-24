import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          SettingsStrings.contactScreenTitle,
          style: AppStyles.headingMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SettingsStrings.getInTouchTitle,
              style: AppStyles.headingMedium.copyWith(
                fontSize: AppStyles.veryBigFontSize,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              SettingsStrings.getInTouchSubtitle,
              style: AppStyles.bodyMedium.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            _buildContactCard(
              icon: Icons.email_outlined,
              title: SettingsStrings.emailTitle,
              subtitle: 'support@afiete.com',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.phone_outlined,
              title: SettingsStrings.phoneTitle,
              subtitle: '+1 (555) 123-4567',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.location_on_outlined,
              title: SettingsStrings.officeTitle,
              subtitle: '123 Healthcare Street\nMedical City, MC 12345',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.schedule_outlined,
              title: SettingsStrings.hoursTitle,
              subtitle:
                  'Monday - Friday: 8:00 AM - 6:00 PM\nSaturday: 9:00 AM - 3:00 PM\nSunday: Closed',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 40),
            Text(
              SettingsStrings.sendMessageSectionTitle,
              style: AppStyles.headingSmall,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: nameController,
              label: SettingsStrings.fullNameLabel,
              hint: SettingsStrings.fullNameHint,
              icon: Icons.person_outline,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              label: SettingsStrings.emailAddressLabel,
              hint: SettingsStrings.emailAddressHint,
              icon: Icons.email_outlined,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: messageController,
              label: SettingsStrings.messageLabel,
              hint: SettingsStrings.messageHint,
              icon: Icons.message_outlined,
              colorScheme: colorScheme,
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: isSubmitting ? null : _submitForm,
              widget: isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      SettingsStrings.sendMessageButton,
                      style: AppStyles.headingSmall.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppStyles.bodySmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ColorScheme colorScheme,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).cardColor,
            prefixIcon: Icon(icon, color: colorScheme.outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.fillAllFieldsError)),
      );
      return;
    }

    if (!emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.invalidEmailError)),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Simulate sending the message
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SettingsStrings.messageSentSuccess),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        // Clear the form
        nameController.clear();
        emailController.clear();
        messageController.clear();

        // Navigate back
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    });
  }
}
