// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileInfoModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileInfoAdapter extends TypeAdapter<ProfileInfo> {
  @override
  final int typeId = 0;

  @override
  ProfileInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileInfo(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      (fields[4] as List).cast<String>(),
      fields[5] as bool,
      fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.fullname)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.standard)
      ..writeByte(4)
      ..write(obj.classList)
      ..writeByte(5)
      ..write(obj.verified)
      ..writeByte(6)
      ..write(obj.stdateduright);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
