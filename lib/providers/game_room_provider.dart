import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/room_model.dart';

class GameRoomProvider extends ChangeNotifier {
  Future<List<Games>> fetchProducts() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    final List<Games> products = snapshot.docs.map((doc) {
      return Games.fromSnapshot(doc);
    }).toList();
    return products;
  }
}
