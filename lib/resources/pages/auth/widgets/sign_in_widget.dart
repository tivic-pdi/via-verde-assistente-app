import 'package:flutter/material.dart';
import 'package:guia_digital/app/models/usuario.dart';
import 'package:guia_digital/resources/pages/home/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:styled_widget/styled_widget.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Acessar')
        .textAlignment(TextAlign.center)
        .textColor(Colors.white)
        .fontSize(14)
        .width(double.infinity)
        .padding(vertical: 15, horizontal: 30)
        .decorated(
          color: Colors.green,
          borderRadius: BorderRadius.circular(35),
        )
        .gestures(onTap: () {
      final usuario =
          Usuario(nmEmail: "edgard@tivic.com.br", nmSenha: "123456");

      Auth.set(usuario);

      routeTo(HomePage.path);
    });
  }
}
