import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/create_room_provider.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key, required this.gameName});
  final String gameName;

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create ${widget.gameName} room"),
        centerTitle: true,
      ),
      body: Consumer<CreateRoomProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: widget.gameName),
                      enabled: false,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Room Name"),
                      controller: provider.roomName,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Room Description"),
                      controller: provider.roomDescription,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Room Size:",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<int>(
                          value: provider.selectedNumber,
                          onChanged: (int? newValue) {
                            setState(() {
                              provider.selectedNumber = newValue!;
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(10,
                              (int index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text((index + 1).toString()),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        provider.setGameName(widget.gameName);

                        provider.createRoom();
                      },
                      child: const Text("Create Room"),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
