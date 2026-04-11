import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/sessions/presentation/cubits/sessions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String sessionId;

  const ReviewBottomSheet({super.key, required this.sessionId});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryFillColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Add Review', style: AppStyles.headingMedium),
            const SizedBox(height: 20),
            Center(
              child: _StarRating(
                rating: _rating,
                onRatingChanged: (newRating) {
                  setState(() => _rating = newRating);
                },
              ),
            ),
            const SizedBox(height: 24),
            Text('Write comment', style: AppStyles.headingSmall),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'write your comment here',
                hintStyle: AppStyles.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.primaryFillColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _rating > 0 && _commentController.text.isNotEmpty
                    ? () {
                        context.read<SessionsCubit>().submitReview(
                          sessionId: widget.sessionId,
                          rating: _rating,
                          comment: _commentController.text,
                        );
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  const _StarRating({required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i <= 5; i++)
          GestureDetector(
            onTap: () => onRatingChanged(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                i <= rating ? Icons.star : Icons.star_outline,
                color: AppColors.primaryColor,
                size: 40,
              ),
            ),
          ),
      ],
    );
  }
}
