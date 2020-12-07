class Options {
  int increment;
  int time;
  int negRatingRange;
  int posRatingRange;
  bool isRated;
  bool isPublic;
  bool allowPremades;

  Options(
      {this.negRatingRange,
      this.allowPremades,
      this.time,
      this.increment,
      this.posRatingRange,
      this.isPublic,
      this.isRated});
}
