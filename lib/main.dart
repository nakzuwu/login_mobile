import 'package:flutter/material.dart';
import 'package:flutter_application_4/ui/detail_page.dart';
import 'package:flutter_application_4/ui/login_page.dart';
import 'package:flutter_application_4/ui/register_page.dart';
import 'package:flutter_application_4/ui/home_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context)=> LoginPage(),
        '/register': (context)=> RegisterPage(),
        '/home': (context)=> HomePage(),
      },
    );
  }
}