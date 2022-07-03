import 'package:chat_app/screen/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        SizedBox(
          height: size.height / 20,
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: size.width / 0.5,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
        ),
        SizedBox(
          height: size.height / 50,
        ),
        Container(
          width: size.width / 1.1,
          child: Text(
            "Welcome",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: size.width / 1.1,
          child: Text(
            "Sign In To Continue!",
            style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 25,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: size.height / 6,
        ),
        Container(
          width: size.width,
          alignment: Alignment.center,
          child: field(size, Icons.account_box, "Email", _email),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Container(
            width: size.width,
            alignment: Alignment.center,
            child: field(size, Icons.lock, "Password", _password),
          ),
        ),
        SizedBox(
          height: size.height / 15,
        ),
        customButton(size),
        SizedBox(
          height: size.height / 40,
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateAccountScreen())),
          child: Text(
            "Don't have an account? Create One",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        )
      ]),
    );
  }

  Widget field(Size size, IconData icon, String hintText,
      TextEditingController controller) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 9, 66, 110)),
        alignment: Alignment.center,
        child: Text(
          "Login",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
