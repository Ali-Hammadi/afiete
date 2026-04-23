import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/articles/domain/entities/article_entities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorArticlesCommentsWidget extends StatelessWidget {
  final List<ArticleEntity> articles;
  final ValueChanged<ArticleEntity> onLike;
  final ValueChanged<ArticleEntity> onDislike;

  const DoctorArticlesCommentsWidget({
    super.key,
    required this.articles,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: articles.asMap().entries.map((entry) {
        final index = entry.key;
        final article = entry.value;

        return Column(
          children: [
            DoctorArticleCommentItem(
              article: article,
              onLike: () => onLike(article),
              onDislike: () => onDislike(article),
            ),
            if (index != articles.length - 1) const Divider(height: 20),
          ],
        );
      }).toList(),
    );
  }
}

class DoctorArticleCommentItem extends StatefulWidget {
  final ArticleEntity article;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const DoctorArticleCommentItem({
    super.key,
    required this.article,
    required this.onLike,
    required this.onDislike,
  });

  @override
  State<DoctorArticleCommentItem> createState() =>
      _DoctorArticleCommentItemState();
}

class _DoctorArticleCommentItemState extends State<DoctorArticleCommentItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final article = widget.article;
    final formattedDate = DateFormat(
      'd MMM yyyy',
      'en_US',
    ).format(article.createdAt);
    final doctorImage = article.doctor.imageUrl;
    final isNetworkImage = doctorImage.startsWith('http');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 40,
            height: 40,
            color: colorScheme.primary.withValues(alpha: 0.12),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article.doctor.name,
                      style: AppStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: AppStyles.bodySmall.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                article.title,
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isExpanded ? article.content : article.summary,
                style: AppStyles.bodySmall,
                maxLines: _isExpanded ? null : 3,
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Read less' : 'Read more',
                  style: AppStyles.bodySmall.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _ReactionTextButton(
                    icon: Icons.thumb_up_alt_outlined,
                    label: '${article.likesCount}',
                    isActive: article.isLikedByUser,
                    onTap: widget.onLike,
                  ),
                  _ReactionTextButton(
                    icon: Icons.thumb_down_alt_outlined,
                    label: '${article.dislikesCount}',
                    isActive: article.isDislikedByUser,
                    onTap: widget.onDislike,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReactionTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ReactionTextButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark
        ? AppColors.darkPrimaryTextColor
        : AppColors.primarytextColor.withValues(alpha: 0.86);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isActive ? colorScheme.primary : inactiveColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppStyles.bodySmall.copyWith(
              color: isActive ? colorScheme.primary : inactiveColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
