import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Headline1 extends StatelessWidget {
  final String title;
  Headline1({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
