import 'package:hive/hive.dart';

part 'profileInfoModel.g.dart';

@HiveType(typeId: 0)
class ProfileInfo {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String fullname;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String standard;
  @HiveField(4)
  final List<String> classList;
  @HiveField(5)
  final bool verified;
  @HiveField(6)
  final bool stdateduright;
  ProfileInfo(this.username, this.fullname, this.email, this.standard,
      this.classList, this.verified, this.stdateduright);
}
