import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: false, ignoreSsl: true);
  await Permission.microphone.request();

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

class WebwhatsPage extends StatefulWidget {
  const WebwhatsPage({Key? key}) : super(key: key);

  @override
  State<WebwhatsPage> createState() => _WebwhatsPageState();
}

class _WebwhatsPageState extends State<WebwhatsPage> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    final settings = InAppWebViewSettings(
      userAgent: desktopUserAgent,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      useOnDownloadStart: true,
      allowsInlineMediaPlayback: true,
    );
    final contextMenu = ContextMenu(
      settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
    );

    return WillPopScope(
      child: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(webWhatsappUrl)),
          initialSettings: settings,
          contextMenu: contextMenu,
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },
          onPermissionRequest: (controller, request) async =>
              PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT),
          onDownloadStartRequest: (controller, url) async {
            await FlutterDownloader.enqueue(
              url: url.url.toString(),
              savedDir: (await getExternalStorageDirectory())!.path,
              showNotification:
                  true, // show download progress in status bar (for Android)
              openFileFromNotification:
                  true, // click on notification to open downloaded file (for Android)
            );
          },
        ),
      ),
      onWillPop: () async {
        if (_webViewController != null) {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
          }
          return false;
        }
        return true;
      },
    );
  }
}
