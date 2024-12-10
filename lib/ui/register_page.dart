import 'package:flutter/material.dart';
import 'package:flutter_application_4/service/auth_service.dart';
import 'package:flutter_application_4/service/session_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reTypePasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final SessionService _sessionService = SessionService();

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  void _regiter()async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.register(
          _nameController.text, 
          _emailController.text,
          _passwordController.text
          );

        if (response["status"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response["message"]))
          );
        } else {
          setState(() {
            _nameError = response["error"]['name']?[0];
            _passwordError = response["error"]['password']?[0];
            _emailError = response["error"]['email']?[0];
          });          
        }

        print(await _sessionService.getToken());
        
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
      appBar: AppBar(title: Text("Register"),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name', errorText: _nameError
                ),
                validator: (value) {
                  if (value==null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email', errorText: _emailError
                ),
                validator: (value) {
                  if (value==null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
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
                  labelText: 'Password', errorText: _passwordError
                ),
                validator: (value) {
                  if (value==null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
              ),
              // retype password
              TextFormField(
                controller: _reTypePasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Retype Password', errorText: _passwordError
                ),
                validator: (value) {
                  if (value==null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(onPressed: (){
                _regiter();
              }, child: Text("Register"))
            ],
          ),
        ),
      ),
    );
  }
}