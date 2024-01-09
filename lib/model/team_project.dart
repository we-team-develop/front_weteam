class TeamProject {
  final String img;
  final String title;
  final String description;
  final int memberSize;
  final String date;

  const TeamProject(
      {this.img = "",
      this.title = "",
      this.description = "",
      this.memberSize = -1, // 입력 안 된 경우를 구분할 수 있어야 함
      this.date = ""});
}
