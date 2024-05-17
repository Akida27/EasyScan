import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        /* title: const Text('Login'),
          centerTitle: true, */
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
                onPressed: _launchUrl,
                // onPressed: () {
                //   Navigator.restorablePushNamed(
                //     context,
                //     CustomersView.routeName,
                //   );
                // },
                child: const Text(
                  'Logga in med Fortnox',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (kDebugMode) {
    print('_launchUrl');
  }
  const url =
      'https://apps.fortnox.se/oauth-v1/auth?client_id=7YFbHiTM1Avu&scope=customer%20article&state=somestate123&access_type=offline&response_type=code&account_type=service';
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    // Visa ett användarvänligt felmeddelande
    debugPrint('Could not launch $url');
    // Till exempel, använd en Snackbar för att informera användaren
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open the link')));
  }
}
