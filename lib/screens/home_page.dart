import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/models/game_model.dart';
import 'package:game_chat_1/screens/widgets/custom_grid_view.dart';
import 'package:game_chat_1/screens/widgets/status_messages.dart';
import 'package:game_chat_1/sevices/connection_service.dart';
import 'package:game_chat_1/sevices/game_list_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConnectionService connectionService;

  final GamesListService gameListService = GamesListService();

  @override
  void initState() {
    super.initState();
    connectionService = ConnectionService(gameListService);
    connectionService.watchConnectivity(gameListService);
    gameListService.getGames();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<bool> checkInternetConnection() async {
  //   gameListService.isConnectionAvailable =
  //       await connectionService.isInternetConnectionAvailable();
  //   if (!gameListService.isConnectionAvailable) {
  //     gameListService.isGamesLoading = false;
  //     gameListService.isConnectionAvailable = false;
  //     gameListService
  //         .addGamesError('internet connection is currently not available');
  //   }
  //   return gameListService.isConnectionAvailable;
  // }

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
      body: SafeArea(
        child: StreamBuilder(
          initialData: const [],
          stream: gameListService.getGamesList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!gameListService.isConnectionAvailable) {
              return const StatusMessage(
                message: 'No connection',
                bannerMessage: 'none',
                bannerColor: Colors.yellow,
                textColor: Colors.black,
              );
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                if (snapshot.hasError) {
                  return StatusMessage(
                    message: '${snapshot.error}',
                    bannerMessage: !gameListService.isConnectionAvailable
                        ? 'none'
                        : 'error',
                    bannerColor: !gameListService.isConnectionAvailable
                        ? Colors.yellow
                        : Colors.red,
                    textColor: !gameListService.isConnectionAvailable
                        ? Colors.black
                        : Colors.white,
                  );
                } else if (snapshot.hasData) {
                  final gamesList = snapshot.data as List<Games>;
                  return CustomGridView(games: gamesList);
                } else {
                  return const StatusMessage(
                    message: 'error',
                    bannerMessage: 'No internet connection',
                    bannerColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              default:
                return const StatusMessage(
                  message: 'Nothing to Show',
                  bannerMessage: 'nothing',
                  bannerColor: Colors.yellow,
                  textColor: Colors.black,
                );
            }
          },
        ),
      ),
    );
  }
}
