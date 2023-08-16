import 'package:flutter/material.dart';
import 'package:noteworthy/enums/menu_action.dart';
import 'package:noteworthy/services/auth/auth_service.dart';

import '../constants/routes.dart';

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
                    await AuthService.firebase().logOut();
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


