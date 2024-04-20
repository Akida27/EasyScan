import 'package:flutter/material.dart';
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const routeName = '/login_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                'Sign in',
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
                'Don\'t have an account?',
                style: TextStyle(fontSize: 15.0),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Sign up',
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
    );
  }
}
