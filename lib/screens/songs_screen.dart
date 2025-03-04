import 'package:flutter/material.dart';
import 'package:mongo5a/models/song_model.dart';
import 'package:mongo5a/screens/groups_screens.dart';
import 'package:mongo5a/screens/insert_song_screen.dart';
import 'package:mongo5a/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  List<SongModel> songs = [];
  late TextEditingController _nameController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fetchSongs();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GroupsScreen(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InsertSongScreen(),
                  ),
                );
                _fetchSongs();
              },
              child: const Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          var song = songs[index];
          return oneTile(song);
        },
      ),
    );
  }

  void _fetchSongs() async {
    List<SongModel> fetchedSongs = await MongoService().getSongs();
    print('En _fetchSongs: $fetchedSongs');

    setState(() {
      songs = fetchedSongs;
    });
  }

  void _deleteSong(mongo.ObjectId id) async {
    await MongoService().deleteSong(id);
    _fetchSongs();
  }

  void _updateSong(SongModel song) async {
    await MongoService().updateSong(song);
    _fetchSongs();
  }

  void showEditDialog(SongModel song) async {
    _nameController.text = song.name;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar canción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController..text = song.name,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                song.name = _nameController.text;
                _updateSong(song);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  ListTile oneTile(SongModel song) {
    return ListTile(
      title: Text(song.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => showEditDialog(song),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteSong(song.id),
          ),
        ],
      ),
    );
  }
}
