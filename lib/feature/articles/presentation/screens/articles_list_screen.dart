import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/articles/presentation/cubits/articles_cubit.dart';
import 'package:afiete/feature/articles/presentation/widgets/article_card_widget.dart';
import 'package:afiete/feature/doctors/data/datasources/mock_doctors_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlesListScreen extends StatefulWidget {
  final String? doctorId;
  final String? doctorName;
  final String? userDiagnosis;

  const ArticlesListScreen({
    super.key,
    this.doctorId,
    this.doctorName,
    this.userDiagnosis,
  });

  @override
  State<ArticlesListScreen> createState() => _ArticlesListScreenState();
}

class _ArticlesListScreenState extends State<ArticlesListScreen> {
  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() {
    final cubit = context.read<ArticlesCubit>();
    if (widget.doctorId != null) {
      cubit.loadArticlesByDoctor(widget.doctorId!);
    } else {
      cubit.loadArticlesForHome(userDiagnosis: widget.userDiagnosis);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizedDoctorName = widget.doctorId == null
        ? null
        : MockDoctorsData.getMockDoctorById(widget.doctorId!)?['name']
              as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.doctorId != null
              ? '${SettingsStrings.articlesByDoctorTitle} ${localizedDoctorName ?? widget.doctorName ?? SettingsStrings.doctorDefaultName}'
              : SettingsStrings.allArticlesTitle,
          style: AppStyles.headingMedium,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) {
          if (state is ArticlesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticlesLoaded) {
            if (state.articles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      SettingsStrings.noArticlesAvailable,
                      style: AppStyles.headingMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(AppStyles.padding),
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                return ArticleCardWidget(
                  article: article,
                  onDoctorTap: () {
                    Navigator.pushNamed(
                      context,
                      MyRoutes.doctorInfoScreen,
                      arguments: article.doctor,
                    );
                  },
                  onReadMore: () {},
                  onLike: () {
                    context.read<ArticlesCubit>().toggleLike(article);
                  },
                  onDislike: () {
                    context.read<ArticlesCubit>().toggleDislike(article);
                  },
                );
              },
            );
          } else if (state is ArticlesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: AppStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    widget: Text(
                      SettingsStrings.retry,
                      style: AppStyles.bodyMedium.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: _loadArticles,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
