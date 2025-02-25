import 'package:flutter/material.dart';
import 'package:mongo5a/models/group_model.dart';
import 'package:mongo5a/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<GroupModel> groups = [];
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _albumsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _albumsController = TextEditingController();
    _fetchGroups();
  }

  void _fetchGroups() async {
    groups = await MongoService().getGroups();
    print('En fetch $groups');
    setState(() {});
  }

  void _deleteGroup(mongo.ObjectId id) async {
    await MongoService().deleteGroup(id);
    _fetchGroups();
  }

  void _updateGroup(GroupModel group) async {
    await MongoService().updateGroup(group);
    _fetchGroups(); // Actualizar la lista de grupos
  }

  void _showEditDialog(GroupModel group) {
    // recuperar la informacion del objeto GroupModel
    _nameController.text = group.name;
    _typeController.text = group.type;
    _albumsController.text = group.albums.toString();
    // crear un cuadro de dialogo para mostrar y editar la informacion
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Grupo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                decoration: const InputDecoration(labelText: 'Albums'),
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
                //Recuperar nuevos valores
                group.name = _nameController.text;
                group.type = _typeController.text;
                group.albums = int.parse(_albumsController.text);
                //Actualizar el grupo en Atlas
                _updateGroup(group);
                Navigator.pop(context);
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // destruir esta screen cuando la app se destruye
    _nameController.dispose();
    _typeController.dispose();
    _albumsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Mongo de grupos de rock')),
      body: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (contexto, index) {
            var group = groups[index];
            return oneTile(group);
            // oneTile(group);
          }),
    );
  }

  ListTile oneTile(GroupModel group) {
    return ListTile(
      title: Text(group.name),
      subtitle: Text(group.type),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showEditDialog(group),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
              onPressed: () => _deleteGroup(group.id),
              icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}
