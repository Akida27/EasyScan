import 'package:easyscan/src/views/login_view.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  static const routeName = '/signup_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100,),
            Image.asset(
              'assets/images/Meza_Nuts.png',
              width: 200,
              height: 200,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
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
                onPressed: () {},
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 15.0),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                      context,
                      LoginView.routeName,
                    );
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color(0xff39328F),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
