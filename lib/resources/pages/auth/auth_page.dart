import 'package:flutter/material.dart';
import 'package:guia_digital/app/controllers/auth_controller.dart';
import 'package:guia_digital/resources/pages/auth/widgets/auth_page_body.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AuthPage extends NyPage<AuthController> {
  static String path = '/auth';

  AuthPage() : super(path);

  @override
  init() async {}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF065F46),
      resizeToAvoidBottomInset: true,
      body: AuthPageBody(),
    );
  }
}
