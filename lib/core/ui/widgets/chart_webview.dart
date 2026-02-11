import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartWebView extends StatelessWidget {
  final String url;

  const ChartWebView({required this.url});

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
