import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/feature/articles/presentation/cubits/articles_cubit.dart';
import 'package:afiete/feature/articles/presentation/widgets/article_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlesHomeSection extends StatelessWidget {
  final String? userDiagnosis;

  const ArticlesHomeSection({super.key, this.userDiagnosis});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesCubit, ArticlesState>(
      builder: (context, state) {
        if (state is ArticlesLoading) {
          return SizedBox(
            height: 200,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is ArticlesLoaded && state.articles.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppStyles.padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Best articles for you',
                      style: AppStyles.headingMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: AppStyles.padding),
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) {
                    final article = state.articles[index];
                    return ArticleCardWidget(
                      article: article,
                      onReadMore: () {},
                      onLike: () {
                        context.read<ArticlesCubit>().toggleLike(article);
                      },
                      onDislike: () {
                        context.read<ArticlesCubit>().toggleDislike(article);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppStyles.padding),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        MyRoutes.articlesListScreen,
                        arguments: {'userDiagnosis': userDiagnosis},
                      );
                    },
                    child: const Text('See All'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        } else if (state is ArticlesError) {
          return Padding(
            padding: EdgeInsets.all(AppStyles.padding),
            child: Center(child: Text(state.message)),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
