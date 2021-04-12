import 'package:flutter/cupertino.dart';
import 'package:vanish_native/utils/store.dart';
import 'package:vanish_native/utils/store_key.dart';
import 'package:vanish_native/ui/router_args/web_login_view_args.dart';

class HttpStatusManage {
  static Future setHttpStatusCode(int httpStatusCode) async {
    await Store().set(StoreKey.httpStatusCode, httpStatusCode);
  }

  static getHttpStatusCode() async {
    return await Store().get(StoreKey.httpStatusCode);
  }

  static Future checkUnAuthorized(BuildContext context) async {
    if (await Store().get(StoreKey.httpStatusCode) == 401) {
      Navigator.pushReplacementNamed(context, 'init',
          arguments: WebLoginViewArgs(true));
    }
  }
}