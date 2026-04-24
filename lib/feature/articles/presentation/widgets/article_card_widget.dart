import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/articles/domain/entities/article_entities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleCardWidget extends StatefulWidget {
  final ArticleEntity article;
  final VoidCallback onReadMore;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final bool isExpanded;

  const ArticleCardWidget({
    super.key,
    required this.article,
    required this.onReadMore,
    required this.onLike,
    required this.onDislike,
    this.isExpanded = false,
  });

  @override
  State<ArticleCardWidget> createState() => _ArticleCardWidgetState();
}

class _ArticleCardWidgetState extends State<ArticleCardWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formattedDate = DateFormat(
      'd MMM yyyy',
      'en_US',
    ).format(widget.article.createdAt);
    final doctorImage = widget.article.doctor.imageUrl;
    final isNetworkImage = doctorImage.startsWith('http');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.borderRadius * 1.5),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Header
            Row(
              children: [
                // Doctor Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    child: doctorImage.isNotEmpty
                        ? (isNetworkImage
                              ? Image.network(
                                  doctorImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      color: colorScheme.primary,
                                    );
                                  },
                                )
                              : Image.asset(
                                  doctorImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      color: colorScheme.primary,
                                    );
                                  },
                                ))
                        : Icon(Icons.person, color: colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                // Doctor Name & Specialty
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.article.doctor.name,
                        style: AppStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        SettingsStrings.specialtyLabel(
                          widget.article.doctor.specialization,
                        ),
                        style: AppStyles.bodySmall.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date
            Text(
              '${SettingsStrings.dateLabel}: $formattedDate',
              style: AppStyles.bodySmall.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: 8),

            // Title
            Text(widget.article.title, style: AppStyles.headingMedium),
            const SizedBox(height: 12),

            // Content / Summary
            Text(
              _isExpanded ? widget.article.content : widget.article.summary,
              style: AppStyles.bodyMedium,
              maxLines: _isExpanded ? null : 3,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Read More / Read Less Button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
                widget.onReadMore();
              },
              child: Text(
                _isExpanded
                    ? SettingsStrings.readLess
                    : SettingsStrings.readMore,
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Like / Dislike Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Like Button
                _buildReactionButton(
                  icon: Icons.thumb_up,
                  label: SettingsStrings.likesLabel(widget.article.likesCount),
                  isActive: widget.article.isLikedByUser,
                  onTap: widget.onLike,
                  colorScheme: colorScheme,
                ),
                // Divider
                Container(
                  height: 24,
                  width: 1,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                // Dislike Button
                _buildReactionButton(
                  icon: Icons.thumb_down,
                  label: SettingsStrings.dislikesLabel(
                    widget.article.dislikesCount,
                  ),
                  isActive: widget.article.isDislikedByUser,
                  onTap: widget.onDislike,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? colorScheme.primary : colorScheme.outline,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppStyles.bodySmall.copyWith(
                  color: isActive ? colorScheme.primary : colorScheme.outline,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
