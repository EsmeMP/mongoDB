import 'package:flutter/material.dart';
import 'package:mongo5a/models/song_model.dart';
import 'package:mongo5a/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

// stf
class InsertSongScreen extends StatefulWidget {
  const InsertSongScreen({super.key});

  @override
  State<InsertSongScreen> createState() => _InsertSongScreenState();
}

class _InsertSongScreenState extends State<InsertSongScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _insertSong() async {
    var song = SongModel(
      id: mongo.ObjectId(),
      name: _nameController.text,
    );
    await MongoService().insertSong(song);
    if (!mounted) return;
    {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar nueva canción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _insertSong,
              child: const Text('Insertar'),
            ),
          ],
        ),
      ),
    );
  }
}
