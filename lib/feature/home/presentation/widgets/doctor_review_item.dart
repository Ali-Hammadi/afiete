import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomDoctorReviewItem extends StatelessWidget {
  const CustomDoctorReviewItem({
    super.key,
    required this.avatarAsset,
    required this.reviewerName,
    required this.reviewTime,
    required this.rating,
    required this.review,
    required this.isExpanded,
    required this.onToggle,
  });

  static const int _reviewPreviewMaxChars = 100;

  final String avatarAsset;
  final String reviewerName;
  final String reviewTime;
  final String rating;
  final String review;
  final bool isExpanded;
  final VoidCallback onToggle;

  String _truncateAtWord(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    final truncated = text.substring(0, maxChars);
    final lastSpace = truncated.lastIndexOf(' ');
    if (lastSpace <= 0) return truncated.trimRight();
    return truncated.substring(0, lastSpace).trimRight();
  }

  Widget _buildReviewText({
    required BuildContext context,
    required String review,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isTruncatable = review.length > _reviewPreviewMaxChars;
    final preview = _truncateAtWord(review, _reviewPreviewMaxChars);

    return GestureDetector(
      onTap: isTruncatable ? onToggle : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.padding / 2),
        child: RichText(
          text: TextSpan(
            style: AppStyles.bodyMedium,
            children: [
              TextSpan(text: isExpanded || !isTruncatable ? review : preview),
              if (isTruncatable && !isExpanded)
                TextSpan(text: '...', style: AppStyles.bodyMedium),
              if (isTruncatable)
                TextSpan(
                  text: isExpanded
                      ? '\u00A0Read\u00A0less'
                      : '\u00A0Read\u00A0more',
                  style: AppStyles.bodySmall.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(radius: 20, backgroundImage: AssetImage(avatarAsset)),
            Expanded(
              child: ListTile(
                title: Text(reviewerName),
                subtitle: Text(reviewTime),
                trailing: SizedBox(
                  width: 56,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_outline, color: colorScheme.primary),
                      Text(rating, style: AppStyles.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        _buildReviewText(
          context: context,
          review: review,
          isExpanded: isExpanded,
          onToggle: onToggle,
        ),
      ],
    );
  }
}
