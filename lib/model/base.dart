abstract class BaseModel {
  String id;
  String createdUserEmail;
  String updatedUserEmail;
  DateTime created;
  DateTime updated;

/*
  BaseModel();
  BaseModel(
      {this.id,
      this.createdUserEmail,
      this.updatedUserEmail,
      this.created,
      this.updated});
*/
  fromMap(Map<String, dynamic> map) {
    id = map['id'];
    createdUserEmail = map['createdUserEmail'];
    updatedUserEmail = map['updatedUserEmail'];
    created = DateTime.tryParse(map['created']);
    updated = DateTime.tryParse(map['updated']);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['createdUserEmail'] = createdUserEmail;
    map['updatedUserEmail'] = updatedUserEmail;
    map['created'] = created;
    map['updated'] = updated;
    return map;
  }
}
