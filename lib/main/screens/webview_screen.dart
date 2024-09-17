import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatelessWidget {

  final String url;

  WebviewScreen(this.url);

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse(url));
    return Scaffold
      (
      appBar: AppBar(),
      body: WebViewWidget(controller: controller,),
    );
  }
}
