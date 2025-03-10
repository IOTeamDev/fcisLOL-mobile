import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lol/core/utils/components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatelessWidget {
  final String url;

  const WebviewScreen(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) async {
          final uri = Uri.parse(request.url);
          if (request.url.startsWith('whatsapp://')) {
            launchUrl(Uri.parse(request.url)); // Opens the URL with an external app
            return NavigationDecision.prevent; // Prevent WebView from handling it
          }
          if (request.url.startsWith('https://www.youtube.com') ||
              request.url.startsWith('https://youtu.be')) {
            await launchUrl(Uri.parse(request.url)); // Opens the URL with an external app
            return NavigationDecision.prevent; // Prevent WebView from handling it
          }

          if (uri.scheme != 'http' && uri.scheme != 'https') {
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                showToastMessage(message: 'Cannot open link: ${uri.scheme} not supported', states: ToastStates.INFO);
              }
            } catch (e) {
              print("Error launching $uri: $e");
            }
            return NavigationDecision.prevent; // Prevent WebView from handling it
          }

          // Allow WebView to load http/https links as usual
          return NavigationDecision.navigate;
        },
      ))..loadRequest(Uri.parse(url));
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(controller: controller,),
    );
  }
}
