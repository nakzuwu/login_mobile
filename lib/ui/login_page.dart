import 'package:flutter/material.dart';
import 'package:flutter_application_4/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  String? _emailError;

  String? _passwordError;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.login(
          _emailController.text,
          _passwordController.text
          );

        if (response["status"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"]))
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"]))
          ); 
        }
        
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: $e'))
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // email
              TextFormField(
                controller: _emailController,
                decoration:
                    InputDecoration(labelText: 'Email', errorText: _emailError),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'enter a valid email';
                  }
                  return null;
                },
              ),
              // password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password', errorText: _passwordError),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    _login();
                  },
  
                  child: Text("Register")),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, '/register');
              }, child: Text("Tidak akun? Daftar disini."))
            ],
          ),
        ),
      ),
    );
  }
}
