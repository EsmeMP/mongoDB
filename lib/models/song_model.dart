import 'package:mongo_dart/mongo_dart.dart' as mongo;

class SongModel {
  final mongo.ObjectId id;
  String name;

  SongModel({
    required this.id,
    required this.name,
  });

  // dart a json
  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }

  // json a dart

  factory SongModel.fromJson(Map<String, dynamic> json) {
    var id = json['_id'];

    if (id is String) {
      try {
        id = mongo.ObjectId.fromHexString(id);
      } catch (e) {
        id = mongo.ObjectId();
      }
    } else if (id is! mongo.ObjectId) {
      id = mongo.ObjectId();
    }

    return SongModel(
      id: id as mongo.ObjectId,
      name: json['name'] as String,
    );
  }
}
