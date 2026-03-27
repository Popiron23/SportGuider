import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportguider/core/enums/role.dart';

class ProfileRoleStorage {
  static const _roleKey = 'profile_role';

  static Future<void> saveRole(Role role) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_roleKey, role.name);
  }

  static Future<Role> readRole() async {
    final preferences = await SharedPreferences.getInstance();
    final roleName = preferences.getString(_roleKey);

    if (roleName == null) {
      return Role.user;
    }

    for (final role in Role.values) {
      if (role.name == roleName) {
        return role;
      }
    }

    return Role.user;
  }

  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_roleKey);
  }
}
