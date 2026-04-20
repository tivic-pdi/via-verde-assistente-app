import 'package:guia_digital/resources/pages/home/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '/app/controllers/home_controller.dart';

class SessionPage extends NyPage<HomeController> {
  static String path = '/session';

  SessionPage() : super(path);

  @override
  init() async {
    routeTo(HomePage.path, navigationType: NavigationType.popAndPushNamed);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
