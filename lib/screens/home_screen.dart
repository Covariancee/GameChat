import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/sevices/connection_service.dart';
import 'package:game_chat_1/sevices/game_list_service.dart';
import 'package:provider/provider.dart';

import '../providers/homepage_provider.dart';
import 'game_rooms.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConnectionService connectionService;

  // late RoomListService roomListService;
  final GamesListService gamesListService = GamesListService();

  // final ScrollController scrollController = ScrollController();
  //more room loading tric

  @override
  void initState() {
    super.initState();
    connectionService = ConnectionService(gamesListService);
    connectionService.watchConnectivity(gamesListService);
    gamesListService.getGamesList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> checkInternetConnection() async {
    gamesListService.isConnectionAvailable =
        await connectionService.isInternetConnectionAvailable();
    if (!gamesListService.isConnectionAvailable) {
      gamesListService.isGamesLoading = false;
      gamesListService.isConnectionAvailable = false;
      gamesListService
          .addGamesError('internet connection is currently not available');
    }
    return gamesListService.isConnectionAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: Consumer<HomePageProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: SizedBox(
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: provider.games.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return GameRooms(
                              gameName: provider.games[index].name,
                            );
                          },
                        ));
                      },
                      child: Card(
                        color: Colors.amber,
                        child: Center(child: Text(provider.games[index].name)),
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
