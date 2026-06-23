import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  //Hive--> do not have tables but boxes-->expense box
  static const String boxName =
      'expenses';

  static Future<Box> openBox()
  async {
    return await Hive.openBox(
      boxName,
    );
  }
}