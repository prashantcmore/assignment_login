import 'package:assignment_login/modules/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_login/modules/httpexception.dart';
import 'package:assignment_login/screens/home_screen.dart';

enum AuthMode { SignUp, SignIn }

class Authentification extends StatelessWidget {
  const Authentification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/images/first.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50, left: 50),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(80)),
                            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1, offset: (Offset.zero))],
                            color: Colors.white),
                        child: AuthCard(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class AuthCard extends StatefulWidget {
  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode _authMode = AuthMode.SignIn;
  final GlobalKey<FormState> _formKey = GlobalKey();

  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  var _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamed(HomeScreen.routeName);
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.SignIn) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'].toString(),
          _authData['password'].toString(),
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.SignIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.SignIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              child: Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 20),
                    child: Text(
                      "Sign Up to continue",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(hintText: 'E-Mail or Phone', prefixIcon: Icon(Icons.email_outlined)),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.045,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    fillColor: Colors.blue,
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
              ),
            ),
            if (_authMode == AuthMode.SignUp)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(Icons.remove_red_eye_outlined),
                      ),
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                ),
              ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Forgot Password ?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
            ),
          ]),
        ),
        Column(
          children: [
            RaisedButton(
              child: Text(_authMode == AuthMode.SignIn ? 'Sign In' : 'SIGN UP'),
              onPressed: () => _submit(),
              // _submit(),
              //  Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
              color: Colors.blue[200],
              textColor: Colors.blue,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.002),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have account ?",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
                FlatButton(
                    child: Text(
                      ' ${_authMode == AuthMode.SignIn ? 'SIGNUP' : 'SIGNIN'} ',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    onPressed: _switchAuthMode,
                    textColor: Colors.black),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
