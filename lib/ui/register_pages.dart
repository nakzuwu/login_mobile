import 'package:flutter/material.dart';
import 'package:flutter_application_4/service/auth_service.dart';

class RegisterPages extends StatefulWidget {
  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _retypePasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  String? _nameError;

  String? _emailError;

  String? _passwordError;

  void _register()async{
    if(_formKey.currentState!.validate()){
      print(_nameController.text);
      try{ 
        final response = await _authService.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );
        if(response["status"]){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('hoerrr'),),
          );
          print("berhasil");
        }else{
          setState((){
          _nameError = response["error"]['name']?[0];
          _passwordError = response["error"]['password']?[0];
          _emailError = response["error"]['email']?[0];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('hdj'),),
          );
        });}
      }catch (e){
        print(e);

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
              //name
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(
                  labelText: 'Name', errorText: _nameError
                ),
                validator: (value){
                  if (value==null||value.isEmpty){
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              //email
              TextFormField(
                controller: _emailController,
                decoration:  InputDecoration(
                  labelText: 'Email', errorText: _emailError
                ),
                validator: (value){
                  if (value==null||value.isEmpty){
                    return 'Please enter your name';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              //pass
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration:  InputDecoration(
                  labelText: 'Password', errorText: _passwordError
                ),
                validator: (value){
                  if (value==null||value.isEmpty){
                    return 'Please enter your Password';
                  }
                },
              ),
              //retype pssword
              TextFormField(
                controller: _retypePasswordController,
                obscureText: true,
                decoration:  InputDecoration(
                  labelText: 'Retype Password', errorText: _passwordError
                ),
                validator: (value){
                  if (value==null||value.isEmpty){
                    return 'Please Retype your Password';
                  }
                },
              ),
              ElevatedButton(onPressed: (){
                _register();
              }, child: Text("Register"))
            ],
          ),
        ),
      ),
    );
  }
}