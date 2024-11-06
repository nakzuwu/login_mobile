import 'package:flutter/material.dart';
import 'package:flutter_application_4/ui/login_pages.dart';
import 'package:flutter_application_4/ui/register_pages.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/':(context)=> LoginPage(),
        '/register':(context)=> RegisterPages(),
      },
    );
  }
}