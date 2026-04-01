import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';

class CwSubpageScaffold extends StatelessWidget {
  const CwSubpageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.useCloseButton = false,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool useCloseButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCwBg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(useCloseButton ? Icons.close : Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: actions,
      ),
      body: body,
    );
  }
}
