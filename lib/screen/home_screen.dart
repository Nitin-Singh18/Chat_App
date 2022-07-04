import 'package:chat_app/auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userMap;
  final TextEditingController _search = TextEditingController();
  bool isLoading = false;

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 9, 66, 110),
          title: Text("Home Screen"),
          actions: [
            IconButton(
                onPressed: () {
                  lgoOut(context);
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    height: size.height / 14,
                    width: size.width,
                    alignment: Alignment.center,
                    child: Container(
                      height: size.height / 14,
                      width: size.width / 1.15,
                      child: TextField(
                        controller: _search,
                        decoration: InputDecoration(
                          hintText: "Search",
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
                      onPressed: () {
                        onSearch();
                      },
                      child: Text("Search")),
                  userMap != null
                      ? ListTile(
                          onTap: () {},
                          leading: Icon(
                            Icons.account_box,
                            color: Colors.black,
                          ),
                          title: Text(
                            userMap!['name'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            userMap!['email'],
                            style: TextStyle(),
                          ),
                          trailing: Icon(
                            Icons.chat,
                            color: Colors.black,
                          ),
                        )
                      : Container(),
                ],
              ));
  }
}
