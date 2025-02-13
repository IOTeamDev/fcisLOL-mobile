import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static late SharedPreferences sharedpref;

  static initialize() async {
    sharedpref = await SharedPreferences.getInstance();
  }

  static Future<bool> writeData({required String key, required value}) async {
    try {
      if (value is String) return await sharedpref.setString(key, value);
      if (value is bool) return await sharedpref.setBool(key, value);
      if (value is int) return await sharedpref.setInt(key, value);
      if (value is double) return await sharedpref.setDouble(key, value);
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  static dynamic readData({required String key}) async {
    return sharedpref.get(key);
  }

  static Future<bool> removeValue({required String key}) async {
    return await sharedpref.remove(key);
  }
}
