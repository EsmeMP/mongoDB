import 'dart:io';

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
    try {
      _db = await mongo.Db.create(
          'mongodb+srv://meme:Galletas.2580@cluster0.5ohmx.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
      await _db.open();
      _db.databaseName = 'musica';
      print('Conexion exitosa a MongoDB');
    } on SocketException catch (e) {
      print('Error de conexion: $e');
      rethrow;
    }
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
    print('Coleccion obtenida: $collection');
    var groups = await collection.find().toList();
    print('En MongoService: $groups');
    if (groups.isEmpty) {
      print('No se encontraron datos en la coleccion');
    }
    return groups.map((grupo) => GroupModel.fromJson(grupo)).toList();
  }

  Future<void> deleteGroup(mongo.ObjectId id) async {
    final collection = _db.collection('grupos');
    await collection.remove(mongo.where.eq('_id', id));
  }

  Future<void> updateGroup(GroupModel group) async {
    final collection = _db.collection('grupos');
    await collection.updateOne(
      mongo.where.eq('_id', group.id),
      mongo.modify
          .set('name', group.name)
          .set('type', group.type)
          .set('albums', group.albums),
    );
  }
}
