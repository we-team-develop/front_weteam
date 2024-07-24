import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/app_colors.dart';
import 'profile_image_widget.dart';

class LoadingOverlay extends StatelessWidget {
  final String title;

  const LoadingOverlay({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(fit: StackFit.expand, children: [
        // 배경
        const Opacity(
          opacity: 0.5,
          child: ModalBarrier(dismissible: true, color: Colors.black),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedTimi(),
              SizedBox(height: 15.h),
              Text(title,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'NanumGothic',
                      fontWeight: FontWeight.bold,
                      color: AppColors.white))
            ],
          ),
        )
      ]),
    );
  }
}


class AnimatedTimi extends StatefulWidget {
  const AnimatedTimi({super.key});

  @override
  State<AnimatedTimi> createState() => _AnimatedTimiState();
}

class _AnimatedTimiState extends State<AnimatedTimi> {
  late Timer timer;
  int index = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (mounted) {
          index = (index + 1) % 6;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileImageWidget(id: index);
  }
}
