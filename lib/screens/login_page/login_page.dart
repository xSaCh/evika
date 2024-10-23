import 'package:evika/data/constants.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:evika/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final txtCntun = TextEditingController();
  final txtCntpassw = TextEditingController();

  static Widget builder(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(context.read<Repository>()),
      child: LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login Successfully"),
          ));

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => BaseScreen()));
        } else if (state is LoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Invalid Cardentials"),
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),
                  textFields(
                      label: "Email", hintText: "Enter Email", controller: txtCntun),
                  SizedBox(height: 20),
                  textFields(
                      label: "Password",
                      hintText: "Enter Password",
                      isPassword: true,
                      controller: txtCntpassw),
                  SizedBox(height: 50),
                  Center(
                      child: FilledButton(
                    onPressed: () => BlocProvider.of<LoginBloc>(context)
                        .add(LoginPressEvent(txtCntun.text, txtCntpassw.text)),
                    child: Text("Login", style: TextStyle(fontSize: 18)),
                  ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget textFields(
    {required String label,
    required String hintText,
    TextEditingController? controller,
    bool isPassword = false}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(color: greyTextColor, fontSize: 14, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      )
    ],
  );
}
