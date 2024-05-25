import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_defenite_project/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



import '../constants/styles.dart';
import '../main.dart';
import '../services/firebase_auth.dart';
import 'home_page.dart';
class LoginScreen extends StatefulWidget {
  TextEditingController controllerEmail =  TextEditingController();
  TextEditingController controllerPassword =  TextEditingController();
  LoginScreen({Key? key, controllerEmail, controllerPassword}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final FocusNode _focusNode = FocusNode();
  bool _isFilled = false;
  String errorMessage = '';
  bool isLogin = true;
  final mainColor = Colors.green.shade300;
  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: widget.controllerEmail.text,
          password: widget.controllerPassword.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });
    }
  }

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

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controllerPassword.dispose();
    super.dispose();
  }


  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        try {
          await Auth().signInWithEmailAndPassword(email: widget.controllerEmail.text, password: widget.controllerPassword.text).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())));
        } on FirebaseAuthException catch (e) {
          errorMessage = e.message!;
        }
      },
      child: Container(
        width: 250,
        height: 61,
        decoration: BoxDecoration(
          color: Color(0xFF0FD56A),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text('ВОЙТИ', style: GoogleFonts.openSans(
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
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 46),
              child: Column(
                children: [
                  Center(
                    child:
                    Image.asset("assets/img.png", width: 500, height: 150,),
                  ),
                  Text(
                    'Вход',
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: openSans800.color
                    ),
                  ),
                  SizedBox(height: 46,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: widget.controllerEmail,
                        validator: (email) =>
                        email != null && !EmailValidator.validate(email) ?
                        'Введите правильный Email' : null,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade300
                                )
                            ),
                            labelText: 'Введите почту',

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: _isFilled ? Colors.white : Colors.green.shade300
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 26,),
                      TextFormField(
                        controller: widget.controllerPassword,
                        validator: (value) => value !=null && value.length < 6 ? 'Минимум 6 символов' : null,
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
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            hintText: 'Введите пароль',

                            contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade300
                                )
                            ),
                            labelText:  'Пароль',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: _isFilled ? Colors.white : Colors.green.shade300
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 51,),
                      _submitButton(),
                      SizedBox(height: 50,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text('Еще нет аккаунта?', style: GoogleFonts.openSans(
                                    fontWeight: openSans400.fontWeight,

                                ),),
                                TextButton(onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                                }, child: Text('Зарегистрироваться', style: openSans400,))],
                            ),
                          )
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