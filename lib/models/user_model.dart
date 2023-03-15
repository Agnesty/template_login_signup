enum GenderEnum { man, woman }
class UserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? birthDate;
  GenderEnum? gender;

  UserModel({this.id, this.firstName, this.lastName, this.birthDate, this.gender, this.email, this.password});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
      data['id']= this.id;
      data['firstName']= this.firstName;
      data['lastName']= this.lastName;
      data['birthDate']= this.birthDate;
      data['gender']= this.gender!.index;
      data['email']= this.email;
      data['password']= this.password;
    return data;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    birthDate = map['birthDate'];
    gender = map['gender'];
    email = map['email'];
    password = map['password'];
  }
}