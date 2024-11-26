import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:linkati/config/app_hive_config.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/storage/storage_repository.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../../users/presentation/cubit/users_cubit.dart';

class FortuneWheelButton extends StatefulWidget {
  const FortuneWheelButton({
    super.key,
    required this.adsManager,
    required this.usersCubit,
  });

  final AdsManager adsManager;
  final UsersCubit usersCubit;

  @override
  State<FortuneWheelButton> createState() => _FortuneWheelButtonState();
}

class _FortuneWheelButtonState extends State<FortuneWheelButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // الحركة تتكرر للأمام والخلف

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: 200 + _animation.value,
          right: 10,
          child: IconButton(
            onPressed: () {
              if (widget.usersCubit.auth.currentUser == null) {
                AppAlert.showAlert(
                  context,
                  subTitle: "يرجى تسجيل الدخول",
                  confirmText: "تسجيل الدخول",
                  onConfirm: () {
                    AppAlert.dismissDialog(context);
                    Navigator.of(context).pushNamed(
                      AppRoutes.loginRoute,
                    );
                  },
                );
              } else {
                AppAlert.showAlertWidget(
                  context,
                  child: DailySpinView(
                    adsManager: widget.adsManager,
                    usersCubit: widget.usersCubit,
                  ),
                );
              }
            },
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[50],
              ),
              child: const Icon(
                CupertinoIcons.game_controller_solid,
                color: ColorsManager.primaryLight,
                size: 45,
              ),
            ),
          ),
        );
      },
    );
  }
}

class DailySpinView extends StatefulWidget {
  const DailySpinView({
    super.key,
    required this.adsManager,
    required this.usersCubit,
  });
  final AdsManager adsManager;
  final UsersCubit usersCubit;

  @override
  State<DailySpinView> createState() => _DailySpinViewState();
}

class _DailySpinViewState extends State<DailySpinView> {
  final StreamController<int> controller = StreamController<int>();
  DateTime? lastSpinTime;
  bool canSpin = true;

  final List<int> points = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; // الجوائز

  @override
  void initState() {
    super.initState();
    _loadLastSpinTime();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<void> _loadLastSpinTime() async {
    String? lastSpinTimeString = instance<StorageRepository>()
        .getData(key: AppHiveConfig.instance.keyLastSpinTime);
    if (lastSpinTimeString != null) {
      lastSpinTime = DateTime.parse(lastSpinTimeString);
      if (lastSpinTime != null &&
          DateTime.now().difference(lastSpinTime!).inHours < 24) {
        setState(() {
          canSpin = false;
        });
      }
    }
  }

  Future<void> _saveLastSpinTime() async {
    instance<StorageRepository>().setData(
      key: AppHiveConfig.instance.keyLastSpinTime,
      value: DateTime.now().toIso8601String(),
    );
  }

  void _spinWheel({bool isWatchAd = false}) async {
    if (!canSpin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يمكنك اللعب مرة أخرى بعد 24 ساعة.')),
      );
      return;
    }

    int selected = Random().nextInt(points.length);
    controller.add(selected);

    setState(() {
      canSpin = false;

      if (!isWatchAd) {
        lastSpinTime = DateTime.now();
      }
    });

    await Future.delayed(Duration(seconds: 5));

    widget.usersCubit.incrementScoreEvent(
      score: points[selected],
    );

    AppAlert.showAlertWidget(
      // ignore: use_build_context_synchronously
      context,
      dialogBackgroundColor: Colors.transparent,
      dialogType: DialogType.success,
      child: Column(
        children: [
          Text(
            'تهاني احلى نتيجة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryLight,
            ),
          ),
          Text(
            'النتيجة: ${points[selected]}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (!isWatchAd) {
      _saveLastSpinTime();
    }
  }

  void _watchAdAndSpin() {
    widget.adsManager.showRewardedAd(
      onAdClosed: () {
        setState(() {
          canSpin = true;
        });
        _spinWheel(isWatchAd: true);
      },
      onAdFailedToLoad: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'يرجى المحاولة في وقت لاحق.',
            ),
          ),
        );
      },
      onAdFailedToShow: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'يرجى المحاولة في وقت لاحق.',
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('عجلة الجوائز اليومية'),
          SizedBox(height: 20),
          SizedBox(
            height: 300,
            width: 300,
            child: FortuneWheel(
              animateFirst: false,
              selected: controller.stream,
              items: points
                  .map((point) => FortuneItem(
                        child: Text(
                          '$point نقطة',
                          style: TextStyle(fontSize: 18),
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 20),
          CustomButtonWidget(
            onPressed: canSpin ? _spinWheel : null,
            label: 'قم بالدوران الآن',
          ),
          SizedBox(height: 20),
          if (!canSpin && lastSpinTime != null)
            Text(
              'يمكنك اللعب مرة أخرى بعد: '
              '${24 - DateTime.now().difference(lastSpinTime!).inHours} ساعة.',
              style: TextStyle(color: Colors.red),
            ),
          SizedBox(height: 10),
          CustomButtonWidget(
            onPressed: _watchAdAndSpin,
            label: 'شاهد إعلان للدوران',
          ),
        ],
      ),
    );
  }
}
