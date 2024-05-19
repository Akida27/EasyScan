import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse(
    'https://apps.fortnox.se/oauth-v1/auth?client_id=7YFbHiTM1Avu&redirect_uri=myapp://callback&scope=customer%20article&state=solid&access_type=offline&response_type=code&account_type=service');

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const routeName = '/login_view';

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
                onPressed: () => _launchUrl(),
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
}
