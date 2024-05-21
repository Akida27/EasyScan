import 'dart:async';
import 'package:easyscan/src/services/auth_service.dart';
import 'package:easyscan/src/views/scan_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uni_links/uni_links.dart';
import 'views/customer_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'views/login_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _sub;
  final AuthService authService = AuthService();
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
        if (uri != null && uri.scheme == 'easyscan' && uri.host == 'callback') {
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
        print('initUniLinks cached: $e');
      }
    }
  }

  void navigateToCustomersView(String accessToken) {
    if (navigatorKey.currentState != null) {
      if (kDebugMode) {
        print('Navigator state is not null, pushing to CustomersView');
      }
      navigatorKey.currentState?.pushReplacement(
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

  void _handleLoginCallback(String code) async {
    if (kDebugMode) {
      print('_handleLoginCallback');
      print('Authorization code: $code');
    }

    await authService.fetchTokens(code);

    final String? accessToken = await authService.getStoredToken('accessToken');
    if (accessToken != null) {
      navigateToCustomersView(accessToken);
    }
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
                  /* case CustomersView.routeName:
                    return const CustomersView(); */
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);
                  default:
                    return LoginView();
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
