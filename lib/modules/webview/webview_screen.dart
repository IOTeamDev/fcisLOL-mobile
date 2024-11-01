import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
            launchUrl(Uri.parse(request.url)); // Opens the URL with an external app
            return NavigationDecision.prevent; // Prevent WebView from handling it
          }

          // Check if the URL uses a scheme other than http or https
          if (uri.scheme != 'http' && uri.scheme != 'https') {
            try {
              // Attempt to open the URL in an external app
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                // Handle the case where the app for the URL is not available
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Cannot open link: ${uri.scheme} not supported"))
                );
              }
            } catch (e) {
              print("Error launching $uri: $e");
            }
            return NavigationDecision.prevent; // Prevent WebView from handling it
          }

          // Allow WebView to load http/https links as usual
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
