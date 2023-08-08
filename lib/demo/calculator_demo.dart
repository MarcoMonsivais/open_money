import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../src/global_functions.dart';

class CalculatorDemo extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CalculatorDemoState();
  }

}

class CalculatorDemoState extends State<CalculatorDemo> {

  late WebViewController _wbController;

  @override
  void initState() {
    super.initState();
    _wbController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://opencalculadorainversion.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://opencalculadorainversion.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: appBar(context, 'Calculadora'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatActionButton(context),
      bottomNavigationBar: bottomApp(context),
      drawer: menuLateral(context),
      body: WebViewWidget(controller: _wbController),
    );
  }

}