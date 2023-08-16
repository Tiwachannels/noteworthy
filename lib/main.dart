import  'package:flutter/material.dart';
import 'package:noteworthy/services/auth/auth_service.dart';
import 'package:noteworthy/views/noteworthy_view.dart';
import 'package:noteworthy/views/register_view.dart';
import 'package:noteworthy/views/verify_email_view.dart';
import 'constants/routes.dart';
import 'views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        noteworthyRoute: (context) => const NoteworthyView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done: 
              final user = AuthService.firebase().currentUser;
              if(user != null) {
                if (user.isEmailVerified) {
                return const NoteworthyView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
              default:
              return const CircularProgressIndicator();
            }
          },
        );
  }
}





