import 'package:flutter/material.dart';

import '../utils/color.dart';

class FeatureTextBox extends StatelessWidget {
  const FeatureTextBox({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonText,
  }) : super(key: key);

  final String title;
  final String description;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              wordSpacing: 03,
              color: kWhiteColor,
              decoration: TextDecoration.none,
              fontSize: 30,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 37,
        ),
        Text(
          description,
          style: const TextStyle(
              color: kWhiteColor,
              wordSpacing: 04,
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.w200),
        ),
        const SizedBox(
          height: 25,
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom().copyWith(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(06),
                side: const BorderSide(
                  color: kWhiteColor,
                ))),
            padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.hovered)) {
                  return kDartBlue;
                }
                return Colors.transparent;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.hovered)) {
                  return kDartBlue;
                }
                return Colors.transparent;
              },
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: kWhiteColor,
              decoration: TextDecoration.none,
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }
}
