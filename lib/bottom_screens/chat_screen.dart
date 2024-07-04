import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voiceflow Chatbot'),
      ),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          final String contentBase64 = base64Encode(const Utf8Encoder().convert(htmlContent));
          webViewController.loadUrl('data:text/html;base64,$contentBase64');
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  // The HTML content including the Voiceflow chatbot script
  final String htmlContent = '''
  <!DOCTYPE html>
  <html>
  <head><title>Chatbot</title></head>
  <body>
  <script type="text/javascript">
  (function(d, t) {
    var v = d.createElement(t), s = d.getElementsByTagName(t)[0];
    v.onload = function() {
      window.voiceflow.chat.load({
        verify: { projectID: '6589e1630b24e2de29869f3d' },
        url: 'https://general-runtime.voiceflow.com',
        versionID: 'production'
      });
    }
    v.src = "https://cdn.voiceflow.com/widget/bundle.mjs"; 
    v.type = "text/javascript"; 
    s.parentNode.insertBefore(v, s);
  })(document, 'script');
  </script>
  </body>
  </html>
  ''';
}
