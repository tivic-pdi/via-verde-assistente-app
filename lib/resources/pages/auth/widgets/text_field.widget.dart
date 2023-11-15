import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class TextInputWidget extends StatelessWidget {
  final Text label;
  final Icon? icon;
  final bool obscure;

  const TextInputWidget(
      {required this.label, this.icon, this.obscure = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Styled.widget(
            child: ReactiveTextField(
                obscureText: obscure,
                formControl: FormControl(),
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    filled: true,
                    labelText: label.data,
                    prefixIcon: icon,
                    labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                    border: InputBorder.none)))
        .backgroundColor(Colors.blueGrey.shade50)
        //.borderRadius(all: 10)
        .clipRRect(all: 10);
  }
}
