import 'package:finki/widgets/login_widget.dart';
import 'package:finki/widgets/sign_up_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(clickedSignUp: toggle)
      : SignUpWidget(clickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
