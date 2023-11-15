import 'package:flutter/material.dart';
import 'package:guia_digital/resources/pages/auth/widgets/sign_in_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:guia_digital/resources/pages/auth/widgets/text_field.widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AuthPageBody extends StatelessWidget {
  const AuthPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = ThemeProvider.controllerOf(context).currentThemeId ==
        getEnv('DARK_THEME_ID');

    return Column(children: [
      Expanded(
          child: Stack(
        children: [
          FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              height: double.infinity,
              child: FractionallySizedBox(
                  alignment: Alignment.center,
                  widthFactor: 0.5,
                  heightFactor: 0.6,
                  child: Image.asset(getImageAsset("flutter_logo.png"))),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(getImageAsset('toolbar-bg.png')),
                      fit: BoxFit.fitHeight)),
            ),
          ),
          Positioned.fill(
              top: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 0,
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Wrap(runSpacing: 20, children: [
                              TextInputWidget(
                                icon: Icon(Icons.mail_outline,
                                    color: Colors.grey.shade700),
                                label: Text("E-mail"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextInputWidget(
                                icon: Icon(Icons.lock_outline,
                                    color: Colors.grey.shade700),
                                label: Text("Senha"),
                                obscure: true,
                              ),
                              SignInButton(),
                              Text("Recuperar Senha")
                                  .fontSize(14)
                                  .textColor(Colors.black)
                                  .textAlignment(TextAlign.center)
                                  .width(double.infinity)
                            ])),
                      ),
                    ]),
              )),
        ],
      ))
    ]);
  }
}
