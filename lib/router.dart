import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vanish_native/ui/init_view.dart';
import 'package:vanish_native/ui/router_args/web_login_view_args.dart';
import 'package:vanish_native/ui/web_login_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'init':
        return MaterialPageRoute(
          builder: (_) => InitView(),
        );
      case 'webLogin':
        final WebLoginViewArgs args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => WebLoginView(args: args),
        );
    }
  }
}