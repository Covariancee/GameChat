import 'package:flutter/material.dart';

import '../../models/game_model.dart';
import '../game_rooms.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({Key? key, required this.games}) : super(key: key);

  final List<Games> games;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
            ),
            itemCount: games.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return GameRooms(
                        gameName: games[index].name,
                      );
                    },
                  ));
                },
                child: Card(
                  color: Colors.amber,
                  child: Center(child: Text(games[index].name)),
                ),
              );
            }),
      ),
    );
  }
}
