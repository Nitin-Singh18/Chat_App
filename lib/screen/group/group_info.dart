import 'package:chat_app/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupName, groupId;
  const GroupInfo({Key? key, required this.groupName, required this.groupId})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List membersList = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupMembers();
  }

  bool checkAdmin() {
    bool isAdmin = false;
    membersList.forEach((element) {
      if (element['uid'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });
    return isAdmin;
  }

  void getGroupMembers() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((value) {
      setState(() {
        membersList = value['members'];
        isLoading = false;
      });
    });
  }

  void showRemoveDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: ListTile(
            onTap: () => removeUser(index),
            title: Text("Remove this member"),
          ),
        );
      },
    );
  }

  void onLeaveGroup() async {
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });
      String uid = _auth.currentUser!.uid;

      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == uid) {
          membersList.removeAt(i);
        }
      }
      await _firestore.collection('groups').doc(widget.groupId).update({
        "members": membersList,
      });
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } else {
      print("Admin can't leave group.");
    }
  }

  void removeUser(int index) async {
    if (checkAdmin()) {
      if (_auth.currentUser!.uid != membersList[index]['uid']) {
        setState(() {
          isLoading = true;
        });
        String uid = membersList[index]['uid'];
        membersList.removeAt(index);

        //this will update the members of groups
        await _firestore.collection('groups').doc(widget.groupId).update({
          "members": membersList,
        });

        //this will delete the group Id from users collection so that user can't
        //access the group
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(widget.groupId)
            .delete();
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("Can't leave group");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(alignment: Alignment.centerLeft, child: BackButton()),
          Container(
            height: size.height / 14,
            width: size.width / 1.1,
            child: Row(children: [
              Container(
                height: size.height / 11,
                width: size.width / 11,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                child: Icon(
                  Icons.group,
                  size: size.width / 10,
                ),
              ),
              SizedBox(
                width: size.width / 20,
              ),
              Expanded(
                  child: Container(
                child: Text(
                  widget.groupName,
                  style: TextStyle(
                      fontSize: size.width / 16, fontWeight: FontWeight.w500),
                ),
              ))
            ]),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            width: size.width / 1.1,
            child: Text(
              "${membersList.length} members",
              style: TextStyle(
                  fontSize: size.width / 20, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Flexible(
              child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => showRemoveDialog(index),
                      leading: Icon(Icons.account_circle),
                      title: Text(
                        membersList[index]['name'],
                        style: TextStyle(
                            fontSize: size.width / 22,
                            fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(membersList[index]['email']),
                      trailing:
                          Text(membersList[index]['isAdmin'] ? "Admin" : ""),
                    );
                  })),
          ListTile(
            onTap: () => onLeaveGroup(),
            leading: Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
            title: Text(
              "Leave Group",
              style: TextStyle(
                  fontSize: size.width / 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent),
            ),
          )
        ]),
      ),
    ));
  }
}
