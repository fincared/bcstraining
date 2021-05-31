import 'package:bcstraining/model/base.dart';

class Clientex extends BaseModel {
  String nombres;
  String apellidos;
  String color;
  String direccion;


  Clientex();

  Clientex.fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    nombres = map['nombres'];
    apellidos = map['apellidos'];
    color = map['color'];
    direccion = map['direccion'];
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['nombres'] = nombres;
    map['apellidos'] = apellidos;
    map['color'] = color;
    map['direccion'] = direccion;
    return map;
  }

  @override
  String toString() => "Clientex<$id:$nombres>";
}


/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkared/model/empresa.dart';

//import 'package:flutter/foundation.dart'; //@required this.id
//https://medium.com/flutter-community/simple-recipes-app-made-in-flutter-firestore-f386722102da
//https://flutter.institute/firebase-firestore/
class Finca {
  final String id;
  final String nombre;
  final String descripcion;
  final String color;
  final String empresaId;

  Finca(
      {
      this.id,
      this.nombre,
      this.descripcion,
      this.color,
      this.empresaId});

  Finca.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nombre = map['name'],
        descripcion = map['description'],
        color = map['color'],
        empresaId = map['empresaId'];

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['nombre'] = nombre;
    map['descripcion'] = descripcion;
    map['color'] = color;
    map['empresaId'] = empresaId;
    return map;
  }

  @override
  String toString() => "Finca<$id:$nombre>";
}

/**
  class Finca {
    final DocumentReference reference;
    final String id;
    final String nombre;
    final String descripcion;
    final String color;
    final String empresaId;

    Finca(
    {this.reference,
    this.id,
    this.nombre,
    this.descripcion,
    this.color,
    this.empresaId});

    Finca.fromMap(Map<String, dynamic> map, {this.reference})
    : id = reference.documentID,
    nombre = map['name'],
    descripcion = map['description'],
    color = map['color'],
    empresaId = map['empresaId'];

    Finca.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

    Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
    map['id'] = id;
    }
    map['name'] = nombre;
    map['description'] = descripcion;
    map['color'] = color;
    return map;
    }

    @override
    String toString() => "Record<$nombre:$descripcion>";
    }
*/
 */