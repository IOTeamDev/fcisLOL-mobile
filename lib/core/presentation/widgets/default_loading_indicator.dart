import 'package:flutter/material.dart';

// A widget that shows a loading indicator
// This widget is used with a stack so that it can overlay other content
// and prevent user interaction with the underlying content
class DefaultLoadingIndicator extends StatelessWidget {
  const DefaultLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withValues(alpha: 0.3), // Background overlay
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
