import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedUserState {
  bool value;
  Future<bool> read();
  void save(value);
  void delete();
}

class UserState implements SharedUserState {
  bool value;
  final key = 'user_state';

  @override
  Future<bool> read() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(key) ?? false;
    print(value);
    return value;
  }

  void save(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    print(value);
  }

  @override
  void delete() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    print(value);
  }
}
