class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Kuis Pintar';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Aplikasi pembelajaran interaktif untuk mendukung kegiatan bimbingan belajar anak anak desa dalam program KKN.';
  static const String developerName = 'Rangga Saputra';
  static const String teamName = 'Anggota Kelompok KKN 85 Desa Tanjung Harapan';
  static const String kkn = 'KKN 85 Universitas Borneo Tarakan';

  // SharedPreferences Keys
  static const String keyStudentName = 'student_name';
  static const String keyStudentAvatar = 'student_avatar';
  static const String keyIsOnboardingDone = 'is_onboarding_done';
  static const String keyTotalQuizPlayed = 'total_quiz_played';
  static const String keyHighScoreMath = 'high_score_math';
  static const String keyHighScoreBiology = 'high_score_biology';
  static const String keyHighScoreEnglish = 'high_score_english';
  static const String keyProgressMath = 'progress_math';
  static const String keyProgressBiology = 'progress_biology';
  static const String keyProgressEnglish = 'progress_english';
  static const String keyCurrentLevel = 'current_level';
  static const String keyTotalXP = 'total_xp';

  // Subject identifiers
  static const String subjectMath = 'math';
  static const String subjectBiology = 'biology';
  static const String subjectEnglish = 'english';
  static const String subjectAll = 'all'; // Quiz Final — gabungan semua mapel

  // Avatar options (emoji / index)
  static const List<String> avatarOptions = [
    '🐱',
    '🐶',
    '🦊',
    '🐸',
    '🐼',
    '🦁'
  ];

  // Quiz settings
  static const int questionsPerQuiz = 20;
  static const int xpPerCorrectAnswer = 10;
  static const int xpPerQuizComplete = 20;
}

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String quiz = '/quiz';
  static const String lesson = '/lesson';
  static const String profile = '/profile';
  static const String quizResult = '/quiz/result';
}
