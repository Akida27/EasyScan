import 'package:easyscan/src/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

import 'customer_view.dart';

final Uri _url = Uri.parse(
    'https://apps.fortnox.se/oauth-v1/auth?client_id=7YFbHiTM1Avu&redirect_uri=easyscan://callback&scope=customer%20article%20order&state=solid&access_type=offline&response_type=code&account_type=service');

class LoginView extends StatelessWidget {
  LoginView({super.key});
  static const routeName = '/login_view';
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Meza_Nuts.png',
              width: 200,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(325, 53),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: const Color(0xffEEB53A), // background
                  foregroundColor: const Color(0xff39328F), // foreground
                ),
                onPressed: () async {
                  await authService.isAccessTokenValid()
                      ? checkStoredTokens(context)
                      : _launchUrl();
                },
                child: const Text(
                  'Logga in med Fortnox',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (kDebugMode) {
      print('_launchUrl');
    }
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> checkStoredTokens(context) async {
    String? accessToken = await authService.getStoredToken('accessToken');
    String? refreshToken = await authService.getStoredToken('refreshToken');
    if (kDebugMode) {
      //print('$accessToken, $refreshToken');
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomersView(accessToken: accessToken!),
      ),
    );
    if (accessToken != null && await authService.isAccessTokenValid()) {
      // Navigate directly to CustomersView if access token is valid
    } else if (refreshToken != null) {
      // Refresh the access token if the refresh token is available
      accessToken = await authService.refreshAccessToken(refreshToken);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomersView(accessToken: accessToken!),
        ),
      );
    }
  }
}
