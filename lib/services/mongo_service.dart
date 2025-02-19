import 'package:flutter/material.dart';
import 'package:mongo5a/models/group_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoService {
  // Un unico punto de acceso
  static final MongoService _instance = MongoService._internal();

  // La base de datos a conectar
  // late= no puede valer nulo de ninguna manera a comparacion de elvis ?
  late mongo.Db _db;

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  Future<void> connect() async {
    _db = await mongo.Db.create(
        'mongodb+srv://meme:Galletas.2580@cluster0.5ohmx.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
    await _db.open();
  }

  mongo.Db get db {
    if (!_db.isConnected) {
      throw StateError(
          'Base de Datos no inicializada, llama a connect() primero');
    }
    return _db;
  }

  Future<List<GroupModel>> getGroups() async {
    final collection = db.collection('grupos');
    var groups = await collection.find().toList();
    print('En MongoService: $groups');
    return groups.map((grupo) => GroupModel.fromJson(grupo)).toList();
  }
}
