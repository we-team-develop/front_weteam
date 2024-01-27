class WeteamProfile {
  final int userId;
  final int imageIdx;

  const WeteamProfile({required this.userId, required this.imageIdx});

  factory WeteamProfile.fromJson(Map data) {
    return WeteamProfile(userId: data['userId'], imageIdx: data['imageIdx']);
  }
}