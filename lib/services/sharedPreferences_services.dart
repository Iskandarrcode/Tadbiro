import 'package:exam4/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  Future<void> addUserShared(Users user) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final userMap = {
      "id": user.id,
      "user-name": user.name,
      "user-email": user.email,
      "user-imageUrl": user.imageUrl,
    };

    for (var entry in userMap.entries) {
      sharedPreferences.setString(entry.key, entry.value);
    }
  }

  Future<String> _getString(String key, [String defaultValue = '']) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  Future<void> _setString(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  Future<String> getUserId() => _getString("id");
  Future<String> getUserName() => _getString("user-name");
  Future<String> getUserEmail() => _getString("user-email");
  Future<String> getUserImageUrl() => _getString("user-imageUrl");



  Future<void> setUserId(String id) async => _setString('id', id);
  Future<void> setUserFirstName(String userName) async => _setString('user-name', userName);
  Future<void> setUserEmail(String email) async => _setString('user-email', email);
  Future<void> setUserImageUrl(String userImageUrl) async => _setString('user-imageUrl', userImageUrl);
}
