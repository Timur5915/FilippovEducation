import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String name;
  final Color color;
  final Function() handler;
  final Color activeColor;
  final Color disabledColor;
  BottomButton({
    Key key,
    @required this.name,
    this.color = Colors.red,
    this.handler,
    this.activeColor = const Color(0xff6ab941),
    this.disabledColor = const Color(0xffbcbcbc),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 52,
          margin: const EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: 30,
          ),
          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child: FlatButton(
            color: color,
            textColor: Colors.white,
            disabledColor: disabledColor,
            disabledTextColor: Colors.white,
            onPressed: handler,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Text(
              name,
              style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
            ),
          ),
        ),
      ],
    );
  }
}
