import 'package:codeshareclone/utils/color.dart';
import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhiteColor,
      child: Card(
        color: kWhiteColor,
        child: Column(
          children: [
            Text('Your Codeshares'),
            Text('Your Codeshares'),
            Text('Your Codeshares'),
            Text('Your Codeshares'),
          ],
        ),
      ),
    );
  }
}
