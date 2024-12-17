import 'package:equatable/equatable.dart';

class CharacterModel extends Equatable {
  final int id;
  final String origin;
  final String species;
  final String location;
  final String image;
  final String status;
  final String source;
  final String name;
  final String gender;
  final String type;

  const CharacterModel({
    required this.id,
    required this.origin,
    required this.species,
    required this.location,
    required this.image,
    required this.status,
    required this.source,
    required this.name,
    required this.gender,
    required this.type,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      origin: json['origin'] as String,
      species: json['species'] as String,
      location: json['location'] as String,
      image: json['image'] as String,
      status: json['status'] as String,
      source: json['source'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origin': origin,
      'species': species,
      'location': location,
      'image': image,
      'status': status,
      'source': source,
      'name': name,
      'gender': gender,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [
        id,
        origin,
        species,
        location,
        image,
        status,
        source,
        name,
        gender,
        type,
      ];
}
