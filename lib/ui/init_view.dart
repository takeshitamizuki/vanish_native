import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vanish_native/ui/home_view.dart';
import 'package:vanish_native/ui/web_login_view.dart';
import 'package:vanish_native/ui/router_args/web_login_view_args.dart';

class InitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return WebLoginView(args: WebLoginViewArgs(false));
            } else {
              return HomeView();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}