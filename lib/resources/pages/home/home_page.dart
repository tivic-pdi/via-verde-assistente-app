import 'package:flutter/material.dart';
import 'package:guia_digital/resources/pages/home/widgets/camera.widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/home_controller.dart';

class HomePage extends NyPage<HomeController> {
  static String path = '/home';

  @override
  init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: CameraPreviewWidget(),
      ),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      getEnv('DARK_THEME_ID');
}
