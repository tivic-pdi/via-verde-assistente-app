import 'package:flutter_app/resources/pages/auth/auth_page.dart';
import 'package:flutter_app/resources/pages/session.dart';
import 'package:flutter_app/routes/guards/auth_route_guard.dart';

import '../resources/pages/home/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/*
|--------------------------------------------------------------------------
| App Router
|
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.x/router
|--------------------------------------------------------------------------
*/

appRouter() => nyRoutes((router) {
      router.route(
        AuthPage.path,
        (context) => AuthPage(),
      );

      router.route(SessionPage.path, (context) => SessionPage(),
          initialRoute: true);

      router.route(HomePage.path, (context) => HomePage(),
          routeGuards: [AuthRouteGuard()], authPage: true);
    });
