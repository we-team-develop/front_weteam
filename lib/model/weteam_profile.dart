class WeteamProfile {
  final int userId;
  final int imageIdx;

  const WeteamProfile({required this.userId, required this.imageIdx});

  factory WeteamProfile.fromJson(Map data) {
    return WeteamProfile(userId: data['userId'], imageIdx: data['imageIdx']);
  }

  @override
  bool operator ==(Object other) {
    if (other.hashCode == hashCode) return true;
    return other is WeteamProfile &&
        userId == other.userId &&
        imageIdx == other.imageIdx;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(userId, imageIdx);
}
