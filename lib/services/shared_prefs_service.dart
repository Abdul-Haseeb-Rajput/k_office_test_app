import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  //
  Future<bool> setEmailValue({required String emailKey, required String email}) async {
    final sharedPrefsInstance = await SharedPreferences.getInstance();
    return await sharedPrefsInstance.setString(emailKey, email);
  }

  Future<String> getEmailValue({required String emailKey}) async {
    final sharedPrefsInstance = await SharedPreferences.getInstance();
    return sharedPrefsInstance.get(emailKey).toString();
  }

  Future<bool> deleteEmailValue({required String emailKey}) async {
    final sharedPrefsInstance = await SharedPreferences.getInstance();
    return sharedPrefsInstance.remove(emailKey);
  }
}
