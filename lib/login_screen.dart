import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template_login_signup/signup_screen.dart';

import 'database/db_helper.dart';
import 'home_screen.dart';
import 'models/user_model.dart';
import 'widgets/main_logo_header.dart';
import 'widgets/text_form_field.dart';
import 'widgets/validation_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
     dbHelper = DatabaseHelper();
  }

  login() async {
    String email = _conEmail.text;
    String passwd = _conPassword.text;

    if (email.isEmpty) {
      alertDialog(context, "Please Enter User ID");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(email, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("firstName", user.firstName!);
    sp.setString("lastName", user.lastName!);
    sp.setString("email", user.email!);
    sp.setString("password", user.password!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MainLogoHeader('Login'),
              TextFormFieldKu(
                  controller: _conEmail,
                  icon: Icons.email,
                  hintName: 'Email'),
              SizedBox(height: 10.0),
              TextFormFieldKu(
                controller: _conPassword,
                icon: Icons.lock,
                hintName: 'Password',
                isObscureText: true,
              ),
              GestureDetector(
                onTap: login,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  margin: EdgeInsets.all(20.0),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun? '),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()));
                      },
                      child: Center(child: Text('Sign Up', style: TextStyle(color: Colors.blue),)))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}