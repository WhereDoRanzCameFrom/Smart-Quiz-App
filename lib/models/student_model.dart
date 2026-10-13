class StudentModel {
  final String name;
  final String avatarEmoji;
  final int totalQuizPlayed;
  final int highScoreMath;
  final int highScoreBiology;
  final int highScoreEnglish;
  final double progressMath;    // 0.0 - 1.0
  final double progressBiology;
  final double progressEnglish;
  final int currentLevel;
  final int totalXP;

  const StudentModel({
    required this.name,
    this.avatarEmoji = '🐱',
    this.totalQuizPlayed = 0,
    this.highScoreMath = 0,
    this.highScoreBiology = 0,
    this.highScoreEnglish = 0,
    this.progressMath = 0.0,
    this.progressBiology = 0.0,
    this.progressEnglish = 0.0,
    this.currentLevel = 1,
    this.totalXP = 0,
  });

  StudentModel copyWith({
    String? name,
    String? avatarEmoji,
    int? totalQuizPlayed,
    int? highScoreMath,
    int? highScoreBiology,
    int? highScoreEnglish,
    double? progressMath,
    double? progressBiology,
    double? progressEnglish,
    int? currentLevel,
    int? totalXP,
  }) {
    return StudentModel(
      name: name ?? this.name,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      totalQuizPlayed: totalQuizPlayed ?? this.totalQuizPlayed,
      highScoreMath: highScoreMath ?? this.highScoreMath,
      highScoreBiology: highScoreBiology ?? this.highScoreBiology,
      highScoreEnglish: highScoreEnglish ?? this.highScoreEnglish,
      progressMath: progressMath ?? this.progressMath,
      progressBiology: progressBiology ?? this.progressBiology,
      progressEnglish: progressEnglish ?? this.progressEnglish,
      currentLevel: currentLevel ?? this.currentLevel,
      totalXP: totalXP ?? this.totalXP,
    );
  }

  // Total progress keseluruhan (rata-rata 3 subjek)
  double get overallProgress =>
      (progressMath + progressBiology + progressEnglish) / 3;

  // Level berdasarkan XP
  static int levelFromXP(int xp) {
    if (xp < 100) return 1;
    if (xp < 250) return 2;
    if (xp < 500) return 3;
    if (xp < 800) return 4;
    return 5;
  }

  String get levelTitle {
    switch (currentLevel) {
      case 1:
        return 'Pelajar Baru';
      case 2:
        return 'Pelajar Aktif';
      case 3:
        return 'Pelajar Hebat';
      case 4:
        return 'Pelajar Bintang';
      case 5:
        return 'Pelajar Super';
      default:
        return 'Pelajar Baru';
    }
  }
}
