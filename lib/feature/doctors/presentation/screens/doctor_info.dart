import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/core/widget/error_custom_button.dart';
import 'package:afiete/feature/articles/presentation/cubits/articles_cubit.dart';
import 'package:afiete/feature/articles/presentation/widgets/article_card_widget.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/home/presentation/widgets/custom_container.dart';
import 'package:afiete/feature/doctors/presentation/widgets/doctor_review_item.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorInfo extends StatefulWidget {
  final DoctorEntity? doctor;

  const DoctorInfo({super.key, this.doctor});

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  bool _isFirstReviewExpanded = false;
  bool _isSecondReviewExpanded = false;
  bool _isThirdReviewExpanded = false;

  @override
  void initState() {
    super.initState();
    final doctorId = widget.doctor?.id;
    if (doctorId != null && doctorId.isNotEmpty) {
      context.read<ArticlesCubit>().loadArticlesByDoctor(doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final doctor = widget.doctor;
    final doctorName = doctor?.name ?? SettingsStrings.doctorDefaultName;
    final doctorSpecialization =
        doctor?.specialization ?? SettingsStrings.doctorSpecialist;
    final doctorDescription = doctor?.description.isNotEmpty == true
        ? doctor!.description
        : SettingsStrings.doctorProfileUnavailable;

    return Scaffold(
      appBar: AppBar(
        title: Text(doctorName, style: AppStyles.headingMedium),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share, color: colorScheme.onSurface),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(ImageLinks.man1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppStyles.padding),
              child: Text(doctorName, style: AppStyles.headingMedium),
            ),
            _buildStatsCard(colorScheme: colorScheme, doctor: doctor),
            _buildSection(
              title: SettingsStrings.doctorAboutTitle,
              child: SizedBox(
                width: double.infinity,
                child: Text(doctorDescription, style: AppStyles.bodyMedium),
              ),
            ),
            _buildSection(
              title: SettingsStrings.doctorSpecialist,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorSpecialization, style: AppStyles.bodySmall),
                  Text('Cardiology'),
                  Text('CBT'),
                  Text('Depression'),
                ],
              ),
            ),
            _buildSection(
              title: SettingsStrings.doctorPriceContactTitle,
              child: Column(
                children: [
                  _buildPriceServiceTile(
                    title: SettingsStrings.chatTitle,
                    price: '10\$ / min',
                    icon: Icons.chat,
                    colorScheme: colorScheme,
                  ),
                  _buildPriceServiceTile(
                    title: SettingsStrings.videoCallTitle,
                    price: '20\$ / min',
                    icon: Icons.videocam_sharp,
                    colorScheme: colorScheme,
                  ),
                  _buildPriceServiceTile(
                    title: SettingsStrings.voiceCallTitle,
                    price: '15\$ / min',
                    icon: Icons.keyboard_voice_sharp,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
            _buildDoctorArticlesSection(colorScheme: colorScheme),
            _buildReviewsSection(colorScheme: colorScheme),
            SizedBox(height: 20),
            CustomButton(
              widget: Text(
                "Book a session now",
                style: AppStyles.headingSmall.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              onPressed: () {
                // if (doctor == null) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Doctor data not loaded yet.'),
                //     ),
                //   );
                //   return;
                // }

                Navigator.pushNamed(
                  context,
                  MyRoutes.bookSessionScreen,
                  arguments: doctor,
                );
              },
            ),
            SizedBox(height: 20),
            ErrorCustomButton(
              widget: Text(
                "Report Doctor",
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onError,
                ),
              ),
              onPressed: () {
                final authState = context.read<AuthCubit>().state;
                final userId = switch (authState) {
                  AuthLoaded(:final user) => user.id,
                  AuthProfileUpdated(:final user) => user.id,
                  _ => '',
                };

                if (userId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please sign in to report a doctor.'),
                    ),
                  );
                  return;
                }

                Navigator.pushNamed(
                  context,
                  MyRoutes.reportScreen,
                  arguments: ReportScreenArgs(
                    reportType: ReportType.doctor,
                    userId: userId,
                    doctorId: doctor?.id,
                    doctorName: doctorName,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required ColorScheme colorScheme,
    required DoctorEntity? doctor,
  }) {
    return CustomContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text(
                      (doctor?.ratingValue ?? 4.9).toStringAsFixed(1),
                      style: AppStyles.bodySmall,
                    ),
                  ],
                ),
                Text(' Reviews', style: AppStyles.bodySmall),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(doctor?.experience ?? '+ 5 years'),
                Text('Experience', style: AppStyles.bodySmall),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('+1.2K'),
                Text('Patients', style: AppStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.headingSmall),
          const Divider(),
          child,
        ],
      ),
    );
  }

  Widget _buildPriceServiceTile({
    required String title,
    required String price,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(price),
      leading: Icon(icon, size: 28, color: colorScheme.primary),
    );
  }

  Widget _buildReviewsSection({required ColorScheme colorScheme}) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reviews', style: AppStyles.headingSmall),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: AppStyles.bodySmall.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          _buildReviewItem(
            avatarAsset: ImageLinks.man1,
            reviewerName: 'Fadi',
            reviewTime: 'Yesterday',
            rating: '4.8',
            review:
                'Dr. John Doe is an exceptional doctor who provided me with excellent care and support throughout my treatment. He was always attentive to my needs and concerns, and his expertise and professionalism were evident in every interaction. I highly recommend Dr. John Doe to anyone seeking top-notch medical care.',
            isExpanded: _isFirstReviewExpanded,
            onToggle: () => setState(
              () => _isFirstReviewExpanded = !_isFirstReviewExpanded,
            ),
          ),
          const Divider(),
          _buildReviewItem(
            avatarAsset: ImageLinks.man1,
            reviewerName: 'Samer',
            reviewTime: 'Last month',
            rating: '4.9',
            review:
                'this is a very long review that should be truncated to fit in the available space. The doctor was very professional and attentive to my needs. I highly recommend him to anyone looking for a great healthcare provider.',
            isExpanded: _isSecondReviewExpanded,
            onToggle: () => setState(
              () => _isSecondReviewExpanded = !_isSecondReviewExpanded,
            ),
          ),
          const Divider(),
          _buildReviewItem(
            avatarAsset: ImageLinks.woman2,
            reviewerName: 'Maya',
            reviewTime: 'Last week',
            rating: '4.8',
            review:
                'this is a very long review that should be truncated to fit in the available space. The doctor was very professional and attentive to my needs. I highly recommend him to anyone looking for a great healthcare provider.',
            isExpanded: _isThirdReviewExpanded,
            onToggle: () => setState(
              () => _isThirdReviewExpanded = !_isThirdReviewExpanded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorArticlesSection({required ColorScheme colorScheme}) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Articles', style: AppStyles.headingSmall),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MyRoutes.articlesListScreen,
                    arguments: {
                      'doctorId': widget.doctor?.id,
                      'doctorName': widget.doctor?.name,
                    },
                  );
                },
                child: Text(
                  'Read all',
                  style: AppStyles.bodySmall.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          BlocBuilder<ArticlesCubit, ArticlesState>(
            builder: (context, state) {
              if (state is ArticlesLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is ArticlesLoaded) {
                final articles = state.articles;
                if (articles.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No articles available for this doctor yet.',
                      style: AppStyles.bodySmall.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  );
                }

                return Column(
                  children: articles
                      .map(
                        (article) => ArticleCardWidget(
                          article: article,
                          onReadMore: () {},
                          onLike: () {
                            context.read<ArticlesCubit>().toggleLike(article);
                          },
                          onDislike: () {
                            context.read<ArticlesCubit>().toggleDislike(
                              article,
                            );
                          },
                        ),
                      )
                      .toList(),
                );
              }

              if (state is ArticlesError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    state.message,
                    style: AppStyles.bodySmall.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String avatarAsset,
    required String reviewerName,
    required String reviewTime,
    required String rating,
    required String review,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return CustomDoctorReviewItem(
      avatarAsset: avatarAsset,
      reviewerName: reviewerName,
      reviewTime: reviewTime,
      rating: rating,
      review: review,
      isExpanded: isExpanded,
      onToggle: onToggle,
    );
  }
}
