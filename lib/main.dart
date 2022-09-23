import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Webwhats',
      home: WebwhatsPage(),
    );
  }
}

const desktopUserAgent =
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36";
const webWhatsappUrl = "https://web.whatsapp.com/🌎/en/";

class WebwhatsPage extends StatelessWidget {
  const WebwhatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        userAgent: desktopUserAgent,
      ),
    );
    return SafeArea(
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(webWhatsappUrl)),
        initialOptions: options,
        // userAgent: desktopUserAgent,
      ),
    );
  }
}
