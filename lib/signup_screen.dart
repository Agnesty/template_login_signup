import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template_login_signup/login_screen.dart';
import 'package:template_login_signup/widgets/text_form_field.dart';

import 'controller/user_ctr.dart';
import 'database/db_helper.dart';
import 'home_screen.dart';
import 'models/user_model.dart';
import 'widgets/main_logo_header.dart';
import 'widgets/validation_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
 String _selectDateString = 'Select Your Birthday';

  DateTime _selectedDate = DateTime.now();

  final _formKey = new GlobalKey<FormState>();
  final UserController _userController = Get.put(UserController());
  final _conFirstName = TextEditingController();
  final _conLastName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();
  GenderEnum? UserGender;
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  signUp() async {
    String firstName = _conFirstName.text;
    String lastName = _conLastName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;
    String cpasswd = _conCPassword.text;

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (passwd != cpasswd) {
        alertDialog(context, 'Password Mismatch');
      } else {
        _formKey.currentState!.save();

        UserModel uModel = UserModel(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: passwd);
        print(uModel.password);
        await _userController.addUser(userModel: uModel).then((userData) {
          alertDialog(context, "Successfully Saved");

          Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        }).catchError((error) {
          print(error);
          alertDialog(context, "Error: Data Save Fail");
        });
      }
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectDateString = "${_selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // _validateSignUp() {
  //   if (_conEmail.text.isNotEmpty && _conPassword.text.isNotEmpty) {
  //     //add to Database
  //      _addUserToDatabase();
  //      Get.to(()=>HomeScreen());
  //   } else if (_conEmail.text.isEmpty  || _conPassword.text.isEmpty || _conCPassword.text.isEmpty) {
  //     Get.snackbar("Required", "Email, Password, Confirm Password are required!",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.white,
  //         colorText: pinkClr,
  //         icon: Icon(
  //           Icons.warning_amber_rounded,
  //           color: Colors.red,
  //         ));
  //   }
  // }

  // _addUserToDatabase() async {
  //  int value = await _userController.addUser(
  //    userModel: UserModel(
  //     firstName: _conFirstName.text,
  //     lastName: _conLastName.text,
  //     birthDate: DateFormat.yMd().format(_selectedDate),
  //     gender: UserGender,
  //     email: _conEmail.text,
  //     password: _conPassword.text,
  //    )
  //  );
  //  print("My id is "+"$value");
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainLogoHeader('Signup'),
                  TextFormFieldKu(
                      controller: _conFirstName,
                      icon: Icons.person,
                      hintName: 'First Name'),
                  const SizedBox(height: 10.0),
                  TextFormFieldKu(
                      controller: _conLastName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'Last Name'),
                  const SizedBox(height: 10.0),
                  TextFormFieldKu(
                      controller: _conEmail,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  const SizedBox(height: 10.0),
                  TextFormFieldKu(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormFieldKu(
                    controller: _conCPassword,
                    icon: Icons.lock,
                    hintName: 'Confirm Password',
                    isObscureText: true,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.wc,
                          color: Colors.grey,
                        ),
                        Radio(
                          value: GenderEnum.man,
                          groupValue: UserGender,
                          onChanged: (GenderEnum? value) {
                            setState(() {
                              _passDataToParent('gender', 'Man');
                              UserGender = value!;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _passDataToParent('gender', 'Man');
                              UserGender = GenderEnum.man;
                            });
                          },
                          child: Text('Man'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Radio(
                          value: GenderEnum.woman,
                          groupValue: UserGender,
                          onChanged: (GenderEnum? value) {
                            setState(() {
                              _passDataToParent('gender', 'Woman');
                              UserGender = value!;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _passDataToParent('gender', 'Woman');
                              UserGender = GenderEnum.woman;
                            });
                          },
                          child: Text('Woman'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 360,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.cake,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              width: 250,
                              child: Text(_selectDateString),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: signUp,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sudah punya akun?'),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.blue),
                          child: Text('Sign In'),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginScreen()),
                                (Route<dynamic> route) => false);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _passDataToParent(String key, dynamic value) {
    List<dynamic> addData = [];
    addData.add(key);
    addData.add(value);
    // widget.parentAction!(addData);
  }
}