import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import  'package:flutter/material.dart';
import 'package:noteworthy/views/register_view.dart';
import 'package:noteworthy/views/verify_email_view.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';
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
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                  ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done: 
              final user = FirebaseAuth.instance.currentUser;
              if(user != null) {
                if (user.emailVerified) {
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

enum MenuAction { logout }



class NoteworthyView extends StatefulWidget {
  const NoteworthyView({super.key});

  @override
  State<NoteworthyView> createState() => _NoteworthyViewState();
}

class _NoteworthyViewState extends State<NoteworthyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text('Main UI'),
      actions: [
        PopupMenuButton<MenuAction>(onSelected: (value) async {
          switch(value) {
                  case MenuAction.logout:
                  final shouldLogout = await showLogOutDIalog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false,);
                  }
          }
        }, 
        itemBuilder: (context) {
          return [
            const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          )];
          
        })
      ],
    ),
    body: const Text('Hello world'),
    );
  }
}

Future<bool> showLogOutDIalog(BuildContext context) {
 return showDialog<bool>(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          }, child: const Text('Cancel')             ,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          }, child: const Text('Log out')             ,
        )
      ],
    );
  }
 ).then((value) => value ?? false); 
}


Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(context: context, builder:(context) {
    return AlertDialog(
      title: const Text('An error occurred'),
      content: Text(text),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: const Text('OK')),
      ]
    );
  },);
}