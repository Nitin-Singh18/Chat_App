import 'package:chat_app/auth/firebase_auth.dart';
import 'package:chat_app/screen/home_screen.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
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
                    "Sign Up To Continue!",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: size.height / 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, Icons.person, "Name", _name),
                  ),
                ),
                Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: field(size, Icons.account_box, "Email", _email),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, Icons.lock, "Password", _password),
                  ),
                ),
                SizedBox(
                  height: size.height / 20,
                ),
                customButton(size),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ]));
  }

  Widget field(Size size, IconData icon, String hintText,
      TextEditingController controller) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: controller,
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
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          createAccount(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            } else {
              print("Login Failed");
            }
          });
        } else {
          print("Fill all the fields");
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 9, 66, 110)),
        alignment: Alignment.center,
        child: Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
