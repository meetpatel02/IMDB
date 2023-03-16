import 'package:hive/hive.dart';
import 'package:imdb_task/model/register_model.dart';

class Boxes {
  static Box<RegisterModel> getData() => Hive.box<RegisterModel>('registerUser');
}
