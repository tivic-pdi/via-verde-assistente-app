import 'package:flutter_app/app/controllers/auth_controller.dart';
import 'package:flutter_app/resources/pages/home/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:nylo_framework/theme/helper/ny_theme.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/logo_widget.dart';
import '/resources/widgets/safearea_widget.dart';
import '/bootstrap/helpers.dart';

class AuthPage extends NyPage<AuthController> {
  static String path = '/auth';

  @override
  init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeAreaWidget(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("AuthPage"),
              SizedBox(
                height: 20,
              ),
              Text('Autenticar') // button
                  .textColor(Colors.white)
                  .fontSize(16)
                  .padding(vertical: 15, horizontal: 30)
                  .decorated(
                    color: Color(0xff41508D),
                    borderRadius: BorderRadius.circular(35),
                  )
                  .gestures(onTap: () => routeTo(HomePage.path))
            ],
          ),
        ),
      ),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      getEnv('DARK_THEME_ID');
}
