import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: ((context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done){
          return MyHomeApp();
        }else{
          return MaterialApp();
        }

      }),
      future: Firebase.initializeApp(),
    );
  }

  MaterialApp MyHomeApp() {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: ChatScreen.id,
      routes: <String, WidgetBuilder>{
        WelcomeScreen.id: ((BuildContext context) => WelcomeScreen()),
        ChatScreen.id: ((BuildContext context) => ChatScreen()),
        LoginScreen.id: ((BuildContext context) => LoginScreen()),
        RegistrationScreen.id: ((BuildContext context) => RegistrationScreen()),
        RegistrationScreen.id: ((BuildContext context) => RegistrationScreen()),
      },
    );
  }
}
