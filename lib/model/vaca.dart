import 'package:bcstraining/model/base.dart';

class Vaca extends BaseModel {
  String img;
  String score;
  String raza;
  String finca;


  Vaca();

  Vaca.fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    img = map['img'];
    score = map['score'];
    raza = map['raza'];
    finca = map['finca'];
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['img'] = img;
    map['score'] = score;
    map['raza'] = raza;
    map['finca'] = finca;
    return map;
  }

  @override
  String toString() => "Vaca<$id:$img>";
}

