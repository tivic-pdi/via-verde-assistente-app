import 'package:flutter/material.dart';
import 'package:guia_digital/app/controllers/auth_controller.dart';
import 'package:guia_digital/resources/pages/auth/widgets/auth_page_body.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AuthPage extends NyPage<AuthController> {
  static String path = '/auth';

  @override
  init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          !isThemeDark ? Colors.blueGrey.shade50 : Colors.blueGrey.shade900,
      body: AuthPageBody(),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      getEnv('DARK_THEME_ID');
}
