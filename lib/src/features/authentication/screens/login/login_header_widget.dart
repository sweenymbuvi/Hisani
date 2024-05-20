import 'package:flutter/material.dart';
import 'package:hisani/src/constants/image_strings.dart';
import 'package:hisani/src/constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
            image: AssetImage(tWelcomeScreenImage), height: size.height * 0.2),
        Text(tLoginTitle, style: Theme.of(context).textTheme.headlineLarge),
        Text(tLoginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
