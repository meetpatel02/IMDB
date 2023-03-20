
import 'package:hive/hive.dart';
part 'register_model.g.dart';
@HiveType(typeId: 0)
class RegisterModel extends HiveObject{
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? password;


  RegisterModel({this.name, this.email, this.password,});
}
