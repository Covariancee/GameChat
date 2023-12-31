import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/profile_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String Username = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _getUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        var userName = userSnapshot['username'];
        setState(() {
          Username = userName;
        });
      } else {
        print('User data not found in Firestore.');
      }
    } else {
      print('User is not logged in.');
    }
  }

  @override
  void initState() {
    _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://picsum.photos/250?image=9'),
            radius: 50,
          ),
          const SizedBox(height: 10),
          Text(
            Username,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (BuildContext context, index) {
              return InkWell(
                onTap: () {
                  if (index == 2) {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProfileScreen(Username: Username)));
                  }
                },
                child: ListTile(
                  leading: index == 0 ? const Icon(Icons.settings) : index == 1 ? const Icon(Icons.notifications) : index == 2 ? const Icon(Icons.person) : index == 3 ? const Icon(Icons.home) : const Icon(Icons.home),
                  title: index == 0 ? const Text('Setting') : index == 1 ? const Text('Notifications') : index == 2 ? const Text('Profile') : index == 3 ? const Text('My Rooms') : const Text('My Rooms'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
