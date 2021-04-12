import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:vanish_native/apis/base_api.dart';

void main() {
  runApp(new MaterialApp(home: new WebViewFlutter()));
}

class WebViewFlutter extends StatelessWidget {
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
