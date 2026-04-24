import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/core/widget/error_custom_button.dart';
import 'package:afiete/feature/articles/presentation/cubits/articles_cubit.dart';
import 'package:afiete/feature/articles/presentation/widgets/article_card_widget.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/doctors/data/datasources/mock_doctors_data.dart';
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
    final doctorSpecialization = doctor == null
        ? SettingsStrings.doctorSpecialist
        : SettingsStrings.specialtyLabel(doctor.specialization);
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
              title: SettingsStrings.medicalSpecialtiesLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorSpecialization, style: AppStyles.bodySmall),
                  Text(SettingsStrings.cardiology),
                  Text(SettingsStrings.specialtyLabel('cbtTherapist')),
                  Text(SettingsStrings.depression),
                ],
              ),
            ),
            _buildSection(
              title: SettingsStrings.doctorPriceContactTitle,
              child: Column(
                children: [
                  _buildPriceServiceTile(
                    title: SettingsStrings.chatTitle,
                    price: '10\$ / ${SettingsStrings.minuteAbbreviation}',
                    icon: Icons.chat_bubble_outline,
                    colorScheme: colorScheme,
                  ),
                  _buildPriceServiceTile(
                    title: SettingsStrings.videoCallTitle,
                    price: '20\$ / ${SettingsStrings.minuteAbbreviation}',
                    icon: Icons.videocam_outlined,
                    colorScheme: colorScheme,
                  ),
                  _buildPriceServiceTile(
                    title: SettingsStrings.voiceCallTitle,
                    price: '15\$ / ${SettingsStrings.minuteAbbreviation}',
                    icon: Icons.keyboard_voice_outlined,
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
                SettingsStrings.bookSessionNow,
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
                SettingsStrings.reportDoctorButton,
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
                    SnackBar(
                      content: Text(
                        SettingsStrings.pleaseSignInToReportADoctor,
                      ),
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
                Text(SettingsStrings.reviewsLabel, style: AppStyles.bodySmall),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  SettingsStrings.experienceYearsLabel(
                    doctor?.experience ?? '+ 5 years',
                  ),
                ),
                Text(
                  SettingsStrings.experienceLabel,
                  style: AppStyles.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('+1.2K'),
                Text(SettingsStrings.patientsLabel, style: AppStyles.bodySmall),
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
    final reviews = MockDoctorsData.getMockDoctorReviews(
      widget.doctor?.id ?? '',
    );

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(SettingsStrings.reviewsLabel, style: AppStyles.headingSmall),
              TextButton(
                onPressed: () {},
                child: Text(
                  SettingsStrings.seeAll,
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
            reviewerName: reviews[0]['reviewerName'] as String,
            reviewTime: reviews[0]['reviewTime'] as String,
            rating: reviews[0]['rating'] as String,
            review: reviews[0]['review'] as String,
            isExpanded: _isFirstReviewExpanded,
            onToggle: () => setState(
              () => _isFirstReviewExpanded = !_isFirstReviewExpanded,
            ),
          ),
          const Divider(),
          _buildReviewItem(
            avatarAsset: ImageLinks.man1,
            reviewerName: reviews[1]['reviewerName'] as String,
            reviewTime: reviews[1]['reviewTime'] as String,
            rating: reviews[1]['rating'] as String,
            review: reviews[1]['review'] as String,
            isExpanded: _isSecondReviewExpanded,
            onToggle: () => setState(
              () => _isSecondReviewExpanded = !_isSecondReviewExpanded,
            ),
          ),
          const Divider(),
          _buildReviewItem(
            avatarAsset: ImageLinks.woman2,
            reviewerName: reviews[2]['reviewerName'] as String,
            reviewTime: reviews[2]['reviewTime'] as String,
            rating: reviews[2]['rating'] as String,
            review: reviews[2]['review'] as String,
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
              Text(
                SettingsStrings.articlesLabel,
                style: AppStyles.headingSmall,
              ),
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
                  SettingsStrings.seeAll,
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
                      SettingsStrings.noArticlesAvailableForThisDoctorYet,
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
                          flatMode: true,
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
