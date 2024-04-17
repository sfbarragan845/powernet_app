import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpeedTest extends StatefulWidget {
  const SpeedTest({Key? key}) : super(key: key);
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const SpeedTest(),
    );
  }

  @override
  _SpeedTestState createState() => _SpeedTestState();
}

class _SpeedTestState extends State<SpeedTest>
    with SingleTickerProviderStateMixin {
  final WebViewController _controller = WebViewController();
  @override
  initState() {
    super.initState();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('http://powernet-ec.speedtestcustom.com'));
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speed Test',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
