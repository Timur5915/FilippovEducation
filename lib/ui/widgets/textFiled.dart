import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputTextFiled extends StatelessWidget {
  final String label;
  final bool obscure;
  final TextEditingController controller;
  final String errorText;
  InputTextFiled({this.label, this.obscure, this.errorText, this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            TextField(
                controller: controller,
                style: TextStyle(color: Colors.white),
                obscureText: obscure,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  errorText: errorText != '' ? errorText : null,
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
