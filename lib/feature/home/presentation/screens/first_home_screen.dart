import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/home/presentation/widgets/assignment_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/emotions_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/music_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/top_doctor.dart';
import 'package:flutter/material.dart';

class FirstHomeScreen extends StatelessWidget {
  const FirstHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How are you felling today ?",
                style: AppStyles.headingSmall,
                textAlign: TextAlign.left,
              ),

              EmotionsWidget(),
              AssignmentWidget(),
              MusicWidget(),
              Text("Top Doctors", style: AppStyles.headingMedium),
              TopDoctorsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
