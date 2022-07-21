import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateGroup extends StatelessWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Name"),
        backgroundColor: Color.fromARGB(255, 9, 66, 110),
      ),
      body: Column(children: [
        SizedBox(
          height: size.height / 10,
        ),
        Container(
          height: size.height / 14,
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            height: size.height / 14,
            width: size.width / 1.15,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter Group Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height / 50,
        ),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Color.fromARGB(255, 9, 66, 110)),
            ),
            onPressed: () {},
            child: Text("Create Group")),
      ]),
    );
  }
}
