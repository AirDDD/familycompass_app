import 'dart:math';

class FamilyService {
  static String? familyId;
  static List<String> members = [];

  static String createFamily(String userName) {
    final rand = Random();
    familyId = (100000 + rand.nextInt(900000)).toString(); // 6位家庭ID
    members = [userName];
    return familyId!;
  }

  static bool joinFamily(String id, String userName) {
    if (id.length == 6) {
      familyId = id;
      members.add(userName);
      return true;
    }
    return false;
  }

  static List<String> getMembers() {
    return members;
  }
}
