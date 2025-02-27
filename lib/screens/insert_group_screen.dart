import 'package:flutter/material.dart';
import 'package:mongo5a/models/group_model.dart';
import 'package:mongo5a/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class InsertGroupScreen extends StatefulWidget {
  const InsertGroupScreen({super.key});

  @override
  State<InsertGroupScreen> createState() => _InsertGroupScreenState();
}

class _InsertGroupScreenState extends State<InsertGroupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _albumsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _albumsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _albumsController.dispose();
    super.dispose();
  }

  void _insertGroup() async {
    var group = GroupModel(
      id: mongo.ObjectId(),
      name: _nameController.text,
      type: _typeController.text,
      albums: int.parse(_albumsController.text),
    );
    await MongoService().insertGroup(group);
    if (!mounted) return;
    {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar nuevo grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            TextField(
              controller: _albumsController,
              decoration: const InputDecoration(labelText: 'Álbumes'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _insertGroup,
              child: const Text('Insertar'),
            ),
          ],
        ),
      ),
    );
  }
}
