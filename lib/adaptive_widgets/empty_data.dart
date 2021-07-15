import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyData extends StatelessWidget {
  final title;
  final subtitle;
  EmptyData(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            Lottie.asset(
              './assets/animations/empty_box.json',
              repeat: false,
            ),
          if (MediaQuery.of(context).orientation == Orientation.landscape)
            Lottie.asset('./assets/animations/empty_box.json',
                repeat: false, height: MediaQuery.of(context).size.height / 3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
