import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/constants/sizes.dart';


class TAnimationLoaderWidget extends StatelessWidget {
  const TAnimationLoaderWidget({
    Key? key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  }) : super(key: key);

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        //  Lottie.asset(animation, width: MediaQuery.of(context).size.width * 0.8),
          const SizedBox(height: tDefaultSize),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: tDefaultSize),
          if (showAction)
            SizedBox(
              width: 250,
              child: OutlinedButton(
                onPressed: onActionPressed,
                style: OutlinedButton.styleFrom(backgroundColor: Colors.black),
                child: Text(
                  actionText!,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(color:tWhiteColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
