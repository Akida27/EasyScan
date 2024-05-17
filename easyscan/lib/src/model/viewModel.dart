import 'package:easyscan/main.dart';
import 'package:easyscan/src/views/customer_view.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

void initUniLinks() async {
  try {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      handleLink(initialLink);
    }

    linkStream.listen((String? link) {
      if (link != null) {
        handleLink(link);
      }
    }, onError: (err) {
      print('Failed to get latest link: $err.');
    });
  } on PlatformException {
    print('Failed to get initial link.');
  }
}

void handleLink(String link) {
  Uri uri = Uri.parse(link);
  // Anpassa sökvägen enligt din Redirect URI
  if (uri.path == '/' && uri.host == 'redirect') {
    // Exempel: 'easyScan://redirect/'
    var code = uri.queryParameters['code'];
    var state = uri.queryParameters['state']; // Optionellt, hantera state
    if (code != null) {
      // Använd navigatorKey för att navigera till rätt vy
      navigatorKey.currentState
          ?.pushNamed(CustomersView.routeName, arguments: code);
      print('Authorization code: $code');
    } else {
      print('Authorization code not found.');
    }
  } else {
    print('Unexpected URI: ${uri.toString()}');
  }
}
