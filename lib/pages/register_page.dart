
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_defenite_project/constants/styles.dart';
import 'package:firebase_defenite_project/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../services/firebase_auth.dart';
import 'home_page.dart';
class WelcomeScreen extends StatefulWidget {
  // создание контроллеров для использования их в информаций пользователя
  TextEditingController controllerEmail =  TextEditingController();
  TextEditingController controllerPassword =  TextEditingController();
  TextEditingController controllerConfirm =  TextEditingController();
  TextEditingController controllerCity =  TextEditingController();
  TextEditingController controllerPlace = TextEditingController();
  // создание конструктора
  WelcomeScreen({Key? key, controllerEmail, controllerPassword, controllerConfirm, controllerCity, controllerPlace}) : super(key: key);
  //создание State для динамичности изминяемости данных в классе
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // переменные
  final FocusNode _focusNode = FocusNode();
  bool _isFilled = false;
  String errorMessage = '';
  bool isLogin = true;
  bool _passwordVisible = false;
  final mainColor = Colors.green.shade300;
  String email = '';
  String login = '';
  String city = '';
  Auth auth = Auth();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _focusNode.addListener(() {
      setState(() {
        _isFilled = widget.controllerEmail.text.isNotEmpty &&
            widget.controllerPassword.text.isNotEmpty;
      });
    });
  }
  // регистрация пользователя
  Future<void> createUserWithEmailAndPassword() async {
    try {
      if (_passwordConfirmed()) {
        await Auth().createUserWithEmailAndPassword(
            email: widget.controllerEmail.text,
            password: widget.controllerPassword.text
        ).then((value) {
          users.add({
            'Email': widget.controllerEmail.text,
            'Password': widget.controllerPassword.text,
            'uid': auth.currentUser!.uid,
            'City': widget.controllerCity.text,
            'Place': widget.controllerPlace.text
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        }
        ).catchError((error) {
          setState(() {
            errorMessage = error.toString();
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });
    }
  }
  // функция dispose активируется при выключений приложения, выполняет отключение потоков
  @override
  void dispose() {
    super.dispose();
    widget.controllerPassword.dispose();
    widget.controllerEmail.dispose();
    widget.controllerPlace.dispose();
    _focusNode.dispose();
  }
  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }
  bool _passwordConfirmed() {
    if (widget.controllerPassword.text.trim() ==
        widget.controllerConfirm.text.trim()) {
      return true;
    } else {
      return false;
    }
  }
  Widget _submitButton() {
    return InkWell(
      onTap: createUserWithEmailAndPassword,
      child: Container(
        width: 250,
        height: 61,
        decoration: BoxDecoration(
          color: Color(0xFF0FD56A),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text('РЕГИСТРАЦИЯ', style: GoogleFonts.openSans(
              fontWeight: openSans400.fontWeight,
              fontSize: 18,
              color: Colors.white
          ),),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 10, 60, 46),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Center(
                    child:
                    Image.asset("assets/img.png", width: 250, height: 75,),
                  ),
                  Text(
                    'Регистрация',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: openSans800.color
                    ),
                  ),
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      TextFormField(
                        controller: widget.controllerCity,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade300
                                )
                            ),
                            labelText: 'Введите ваш город',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: _isFilled ? Colors.white : Colors.green
                                      .shade300
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: widget.controllerPlace,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade300
                                )
                            ),
                            labelText: 'Введите ваш адрес',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: _isFilled ? Colors.white : Colors.green
                                      .shade300
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: widget.controllerEmail,
                        validator: (email) =>
                        email != null && !EmailValidator.validate(email) ?
                        'Введите правильный Email' : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade300
                                )
                            ),
                            labelText: 'Введите почту',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: _isFilled ? Colors.white : Colors.green
                                      .shade300
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: widget.controllerPassword,
                        validator: (value) =>
                        value != null && value.length < 6
                            ? 'Минимум 6 символов'
                            : null,
                        obscureText: !_passwordVisible,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              color: Colors.grey.shade300,
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme
                                    .of(context)
                                    .primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            hintText: 'Введите пароль',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade300
                                )
                            ),
                            labelText: 'Пароль',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: _isFilled ? Colors.white : Colors.green
                                      .shade300
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: widget.controllerConfirm,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade300
                                )
                            ),
                            labelText: 'Подтвердите пароль',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: _isFilled ? Colors.white : Colors.green
                                      .shade300
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 20,),
                      _submitButton(),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Уже есть аккаунт?'),
                          TextButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          }, child: Text('Войти', style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF0FD56A)
                          ),))
                        ],
                      ),
                      _errorMessage()
                    ],
                  )

                ],
              ),
            ),
          )
      ),
    );
  }
}