import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vanish_native/apis/base_api.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:vanish_native/ui/router_args/web_login_view_args.dart';
import 'package:vanish_native/utils/shared_preferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebLoginView extends StatefulWidget {
  final WebLoginViewArgs _args;

  WebLoginView({@required WebLoginViewArgs args}) : _args = args;

  @override
  _WebLoginState createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLoginView> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider (
      providers: [
        Provider.value(value: BaseApi())
      ],
      child: WebView(
        initialUrl: 'http://localhost:8080/home.html',
        userAgent: "Chrome/81.0.0.0 Mobile",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
// class WebLoginView extends StatefulWidget {
//   final WebLoginViewArgs _args;
//
//   WebLoginView({@required WebLoginViewArgs args}) : _args = args;
//
//   @override
//   _WebLoginState createState() => _WebLoginState();
// }
//
// class _WebLoginState extends State<WebLoginView> {
//   final cookieManager = WebviewCookieManager();
//
//   String _webUserAgent = '<unknown>';
//
//   StreamSubscription _onDestroy;
//   StreamSubscription<String> _onUrlChanged;
//   StreamSubscription<WebViewStateChanged> _onStateChanged;
//
//   String token;
//
//   @override
//   void dispose() {
//     // Every listener should be canceled, the same should be done with this stream.
//     _onDestroy.cancel();
//     _onUrlChanged.cancel();
//     _onStateChanged.cancel();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _flutterWebViewPlugin.close();
//
//     initUserAgentState();
//
//     // Add a listener to on destroy WebView, so you can make came actions.
//     _onDestroy = _flutterWebViewPlugin.onDestroy.listen((_) {});
//
//     _onStateChanged = _flutterWebViewPlugin.onStateChanged
//         .listen((WebViewStateChanged state) {});
//     _onUrlChanged = _flutterWebViewPlugin.onUrlChanged.listen((String url) {
//       if (mounted) {
//         if (url.startsWith(Urls.topPageUrl)) {
//           _urlChangedFunc();
//         }
//       }
//     });
//   }
//
//   Future _urlChangedFunc() async {
//     await _saveCookie();
//     Navigator.of(context).pushNamedAndRemoveUntil(
//         RoutePaths.Home, (Route<dynamic> route) => false);
//     _flutterWebViewPlugin.close();
//   }
//
//   Future<void> _saveCookie() async {
//     final _cookies = await _flutterWebViewPlugin.getCookies();
//
//     // save to SharedPreferences
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String _sessionId;
//     String _csrfToken;
//     _cookies.forEach((key, value) {
//       if (key.indexOf('SESSION') >= 0) {
//         _sessionId = value;
//       }
//       if (key.indexOf('x-vanish-ctkn') >= 0) {
//         _csrfToken = value.indexOf('"') > 0
//             ? value.replaceAll('"', '')
//             : value; // androidの場合なぜか末尾に"がついているので削除
//       }
//     });
//
//     await prefs.setString(SharedPreferencesKey.session, _sessionId);
//     // POST, PUT, PATCH時に必要
//     await prefs.setString(SharedPreferencesKey.csrfToken, _csrfToken);
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initUserAgentState() async {
//     String webViewUserAgent;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     await FlutterUserAgent.init();
//     webViewUserAgent = FlutterUserAgent.webViewUserAgent;
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _webUserAgent = webViewUserAgent;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String loginUrl =
//     widget._args.unauthorized ? Urls.webLoginTimeoutUrl : Urls.webLoginUrl;
//
//     return WebviewScaffold(
//       url: loginUrl,
//       userAgent: _webUserAgent,
//       clearCookies: true,
//       appCacheEnabled: false,
//     );
//   }
// }