import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easyscan/src/views/scan_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uni_links/uni_links.dart';
import 'views/customer_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'views/login_view.dart';
import 'views/order_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _sub;
  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    if (kDebugMode) {
      print('_initUniLinks');
    }
    try {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null && uri.scheme == 'myapp' && uri.host == 'callback') {
          debugPrint('Received deep link: $uri');
          final code = uri.queryParameters['code'];
          // Perform necessary actions, e.g., navigate to another screen
          if (code != null) {
            _handleLoginCallback(code);
          }
        }
      });
    } catch (e) {
      // Handle exception
      if (kDebugMode) {
        print('initUniLinks catched: $e');
      }
    }
  }

  // void _handleLoginCallback(String code) {
  //   if (kDebugMode) {
  //     print('_handleLoginCallback');
  //     print('Authorization code: $code');
  //   }
  //   // Ensure navigatorKey is not null and then navigate
  //   if (navigatorKey.currentState != null) {
  //     if (kDebugMode) {
  //       print('Navigator state is not null, pushing to CustomersView');
  //     }
  //     navigatorKey.currentState?.pushNamed(CustomersView.routeName);
  //   } else {
  //     if (kDebugMode) {
  //       print('Navigator state is null, cannot push to CustomersView');
  //     }
  //   }
  // }
  void _handleLoginCallback(String code) async {
    if (kDebugMode) {
      print('_handleLoginCallback');
      print('Authorization code: $code');
    }

    final String accessToken = await fetchAccessToken(code);

    // Ensure navigatorKey is not null and then navigate
    if (navigatorKey.currentState != null) {
      if (kDebugMode) {
        print('Navigator state is not null, pushing to CustomersView');
      }
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => CustomersView(accessToken: accessToken),
        ),
      );
    } else {
      if (kDebugMode) {
        print('Navigator state is null, cannot push to CustomersView');
      }
    }
  }

  Future<String> fetchAccessToken(String code) async {
    // Make HTTP POST request to get access token
    // Replace 'yourClientId', 'yourClientSecret', and 'redirectUri' with actual values
    const String apiUrl = 'https://apps.fortnox.se/oauth-v1/token';
    const String clientId = '7YFbHiTM1Avu';
    const String clientSecret = '5fmmL6adDb';
    const String redirectUri = 'myapp://callback';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to fetch access token');
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          /* onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
 */
          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case ScanView.routeName:
                    return const ScanView();
                  // case OrdersView.routeName:
                  //   return const OrdersView();
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);
                  default:
                    return const LoginView();
                }
              },
            );
          },
        );
      },
    );
  }
}
