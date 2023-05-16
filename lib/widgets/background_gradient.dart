
import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.green, Colors.green[900]!],
        end: Alignment.topCenter,
        begin: Alignment.bottomCenter,
      )),
    );
  }
}
