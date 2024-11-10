import 'package:flutter/material.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/color_manager.dart';

class ChallengesDashboardScreen extends StatefulWidget {
  const ChallengesDashboardScreen({super.key});

  @override
  State<ChallengesDashboardScreen> createState() =>
      _ChallengesDashboardScreenState();
}

class _ChallengesDashboardScreenState extends State<ChallengesDashboardScreen> {
  // late final ChallengesCubit _challengesCubit;

  @override
  void initState() {
    // _challengesCubit = context.read<ChallengesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم - التحديات'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButtonWidget(
            width: double.infinity,
            backgroundColor: ColorManager.aed5e5,
            textColor: ColorManager.primaryLight,
            label: "اضافة قسم تحدي جديد",
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.sectionFormRoute,
              );
            },
          ),
        ],
      ),
    );
  }
}
