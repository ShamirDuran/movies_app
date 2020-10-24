import 'package:flutter/material.dart';

class TitleGenerator extends StatelessWidget {
  final String title;

  TitleGenerator({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.0),
          width: 3.5,
          height: 28.0,
          decoration: BoxDecoration(
            color: Colors.indigoAccent,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(title,
              style: Theme.of(context).textTheme.headline5),
        ),
      ],
    );
  }
}
